echo "Verify that the status of the cluster"
gcloud container clusters list

echo "Connect to both clusters to generate entries in the kubeconfig file"
export PROJECT_ID=$(gcloud info --format='value(config.project)')
gcloud container clusters get-credentials client --zone us-west2-a --project ${PROJECT_ID}
gcloud container clusters get-credentials api --zone us-central1-a --project ${PROJECT_ID}

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
#curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=x86_64 sh -
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
kubectl --context=client label namespace istio-system topology.istio.io/network=client-network

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
      network: client-network
  components:
    ingressGateways:
      - name: istio-eastwestgateway
        label:
          istio: eastwestgateway
          app: istio-eastwestgateway
          topology.istio.io/network: client-network
        enabled: true
        k8s:
          env:
            # sni-dnat adds the clusters required for AUTO_PASSTHROUGH mode
            - name: ISTIO_META_ROUTER_MODE
              value: "sni-dnat"
            # traffic through this gateway should be routed inside the network
            - name: ISTIO_META_REQUESTED_NETWORK_VIEW
              value: client-network
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
kubectl --context=api label namespace istio-system topology.istio.io/network=api-network

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
      network: api-network
  components:
    ingressGateways:
      - name: istio-eastwestgateway
        label:
          istio: eastwestgateway
          app: istio-eastwestgateway
          topology.istio.io/network: api-network
        enabled: true
        k8s:
          env:
            # sni-dnat adds the clusters required for AUTO_PASSTHROUGH mode
            - name: ISTIO_META_ROUTER_MODE
              value: "sni-dnat"
            # traffic through this gateway should be routed inside the network
            - name: ISTIO_META_REQUESTED_NETWORK_VIEW
              value: api-network
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
kubectl --context client create ns clientns
kubectl --context api  create ns api-istio
kubectl --context client  create ns nonistio

echo "Enable Istio on coient and api namespace"
kubectl --context client label namespace clientns istio-injection=enabled
kubectl --context api label namespace api-istio istio-injection=enabled

echo "Install api"
cd ~/src/authz/simulation/multi-cluster/multi-network
kubectl --context api apply -f api.yaml
kubectl --context api apply -n api-istio -f istio.yaml

echo "Install client"
kubectl --context client apply -f client.yaml
kubectl --context client -n clientns apply -f istio.yaml