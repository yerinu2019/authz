echo "Set the default network for the api cluster"
kubectl --context=api label namespace istio-system topology.istio.io/network=shared-network

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
      network: shared-network
  components:
    ingressGateways:
      - name: istio-eastwestgateway
        label:
          istio: eastwestgateway
          app: istio-eastwestgateway
          topology.istio.io/network: shared-network
        enabled: true
        k8s:
          env:
            # sni-dnat adds the clusters required for AUTO_PASSTHROUGH mode
            - name: ISTIO_META_ROUTER_MODE
              value: "sni-dnat"
            # traffic through this gateway should be routed inside the network
            - name: ISTIO_META_REQUESTED_NETWORK_VIEW
              value: shared-network
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
istioctl install --context=api -y -f istio-api.yaml

echo "Inspect the deployments in the istio-system namespace."
kubectl --context=api -n istio-system get deployments

echo "Wait for the east-west gateway to be assigned an external IP address"
kubectl --context=api get svc istio-eastwestgateway -n istio-system

echo "Expose all services (*.local) on the east-west gateway in the api cluster."
kubectl --context=api apply -n istio-system -f \
${WORKDIR}/istio-${ISTIO_VERSION}/samples/multicluster/expose-services.yaml