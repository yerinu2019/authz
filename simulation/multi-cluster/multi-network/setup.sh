echo "Download the required files"
cd $HOME
git clone https://github.com/GoogleCloudPlatform/istio-multicluster-gke.git

cd $HOME/istio-multicluster-gke
WORKDIR=$(pwd)

echo "Install kubectx/kubens"
git clone https://github.com/ahmetb/kubectx $WORKDIR/kubectx
export PATH=$PATH:$WORKDIR/kubectx

echo "create the VPCs:"
#gcloud compute networks create vpc-west --subnet-mode=auto
#gcloud compute networks create vpc-central --subnet-mode=auto

echo "Set the KUBECONFIG variable to use a new kubeconfig file"
export KUBECONFIG=${WORKDIR}/istio-kubeconfig

echo "Create two GKE clusters"
gcloud container clusters create client --zone us-west2-a \
    --machine-type "e2-standard-2" --disk-size "50" \
    --scopes "https://www.googleapis.com/auth/compute",\
"https://www.googleapis.com/auth/devstorage.read_only",\
"https://www.googleapis.com/auth/logging.write",\
"https://www.googleapis.com/auth/monitoring",\
"https://www.googleapis.com/auth/servicecontrol",\
"https://www.googleapis.com/auth/service.management.readonly",\
"https://www.googleapis.com/auth/trace.append" \
    --num-nodes "2" --network "vpc-west" --async

gcloud container clusters create api --zone us-central1-a \
    --machine-type "e2-standard-2" --disk-size "50" \
    --scopes "https://www.googleapis.com/auth/compute",\
"https://www.googleapis.com/auth/devstorage.read_only",\
"https://www.googleapis.com/auth/logging.write",\
"https://www.googleapis.com/auth/monitoring",\
"https://www.googleapis.com/auth/servicecontrol",\
"https://www.googleapis.com/auth/service.management.readonly",\
"https://www.googleapis.com/auth/trace.append" \
    --num-nodes "2" --network "vpc-central"

echo "Verify that the status of the cluster"
gcloud container clusters list

echo "Connect to both clusters to generate entries in the kubeconfig file"
export PROJECT_ID=$(gcloud info --format='value(config.project)')
gcloud container clusters get-credentials west --zone us-west2-a --project ${PROJECT_ID}
gcloud container clusters get-credentials central --zone us-central1-a --project ${PROJECT_ID}

echo "Use kubectx to rename the context names for convenience"
kubectx client=gke_${PROJECT_ID}_us-west2-a_client
kubectx api=gke_${PROJECT_ID}_us-central1-a_api

echo "Give yourself (your Google user) the cluster-admin role for both clusters"
kubectl create clusterrolebinding user-admin-binding \
    --clusterrole=cluster-admin --user=$(gcloud config get-value account) \
    --context client
kubectl create clusterrolebinding user-admin-binding \
    --clusterrole=cluster-admin --user=$(gcloud config get-value account) \
    --context api

echo "download Istio"
cd ${WORKDIR}
export ISTIO_VERSION=1.11.2
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=x86_64 sh -
cd istio-${ISTIO_VERSION}
export PATH=$PWD/bin:$PATH

echo "create the secret by using the appropriate certificate files"
for cluster in $(kubectx)
do
  kubectl --context $cluster create namespace istio-system
  kubectl --context $cluster create secret generic cacerts -n istio-system \
    --from-file=${WORKDIR}/istio-${ISTIO_VERSION}/samples/certs/ca-cert.pem \
    --from-file=${WORKDIR}/istio-${ISTIO_VERSION}/samples/certs/ca-key.pem \
    --from-file=${WORKDIR}/istio-${ISTIO_VERSION}/samples/certs/root-cert.pem \
    --from-file=${WORKDIR}/istio-${ISTIO_VERSION}/samples/certs/cert-chain.pem;
  done

echo "set the default network for the client cluster"
kubectl --context=client label namespace istio-system topology.istio.io/network=network1

echo "Create the Istio configuration for the client cluster with a dedicated east-west gateway"
cd ${WORKDIR}
cat <<EOF > istio-client.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  values:
    global:
      meshID: mesh1
      multiCluster:
        clusterName: client
      network: network1
  components:
    ingressGateways:
      - name: istio-eastwestgateway
        label:
          istio: eastwestgateway
          app: istio-eastwestgateway
          topology.istio.io/network: network1
        enabled: true
        k8s:
          env:
            # sni-dnat adds the clusters required for AUTO_PASSTHROUGH mode
            - name: ISTIO_META_ROUTER_MODE
              value: "sni-dnat"
            # traffic through this gateway should be routed inside the network
            - name: ISTIO_META_REQUESTED_NETWORK_VIEW
              value: network1
          service:
            ports:
              - name: status-port
                port: 15021
                targetPort: 15021
              - name: tls
                port: 15443
                targetPort: 15443
              - name: tls-istiod
                port: 15012
                targetPort: 15012
              - name: tls-webhook
                port: 15017
                targetPort: 15017
EOF

echo "Apply the configuration to the client cluster"
istioctl install --context=client -f istio-client.yaml

echo "Inspect the deployments in the istio-system namespace"
kubectl --context=client -n istio-system get deployments

echo "Wait for the east-west gateway to be assigned an external IP address"
kubectl --context=client get svc istio-eastwestgateway -n istio-system

echo "expose all services (*.local) on the east-west gateway in both clusters"
kubectl --context=client apply -n istio-system -f \
${WORKDIR}/istio-${ISTIO_VERSION}/samples/multicluster/expose-services.yaml

echo "Set the default network for the api cluster"
kubectl --context=api label namespace istio-system topology.istio.io/network=network2

echo "Create the Istio configuration for the api cluster with a dedicated east-west gateway"
cd ${WORKDIR}
cat <<EOF > istio-api.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  values:
    global:
      meshID: mesh1
      multiCluster:
        clusterName: api
      network: network2
  components:
    ingressGateways:
      - name: istio-eastwestgateway
        label:
          istio: eastwestgateway
          app: istio-eastwestgateway
          topology.istio.io/network: network2
        enabled: true
        k8s:
          env:
            # sni-dnat adds the clusters required for AUTO_PASSTHROUGH mode
            - name: ISTIO_META_ROUTER_MODE
              value: "sni-dnat"
            # traffic through this gateway should be routed inside the network
            - name: ISTIO_META_REQUESTED_NETWORK_VIEW
              value: network2
          service:
            ports:
              - name: status-port
                port: 15021
                targetPort: 15021
              - name: tls
                port: 15443
                targetPort: 15443
              - name: tls-istiod
                port: 15012
                targetPort: 15012
              - name: tls-webhook
                port: 15017
                targetPort: 15017
EOF

echo "Apply the configuration to the api cluster"
istioctl install --context=api -f istio-api.yaml

echo "Inspect the deployments in the istio-system namespace."
kubectl --context=api -n istio-system get deployments

echo "Wait for the east-west gateway to be assigned an external IP address"
kubectl --context=central get svc istio-eastwestgateway -n istio-system

echo "Expose all services (*.local) on the east-west gateway in the api cluster."
kubectl --context=api apply -n istio-system -f \
${WORKDIR}/istio-${ISTIO_VERSION}/samples/multicluster/expose-services.yaml

echo "Install a remote secret in client cluster that provides access to api cluster's API server."
istioctl x create-remote-secret \
--context=api \
--name=api | \
kubectl apply -f - --context=client

echo "Install a remote secret in api cluster that provides access to client cluster's API server."
istioctl x create-remote-secret \
--context=client \
--name=client | \
kubectl apply -f - --context=api

echo "Create client and api namespace"
kubectl --context client kubectl create ns clientns
kubectl --context api kubectl create ns api-istio
kubectl --context client kubectl create ns nonistio

echo "Enable Istio on coient and api namespace"
kubectl --context client label namespace clientns istio-injection=enabled
kubectl --context api label namespace api-istio istio-injection=enabled