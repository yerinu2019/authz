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
istioctl install --context=client -y -f istio-client.yaml

echo "Inspect the deployments in the istio-system namespace"
kubectl --context=client -n istio-system get deployments

echo "Wait for the east-west gateway to be assigned an external IP address"
kubectl --context=client get svc istio-eastwestgateway -n istio-system

echo "expose all services (*.local) on the east-west gateway in both clusters"
kubectl --context=client apply -n istio-system -f \
${WORKDIR}/istio-${ISTIO_VERSION}/samples/multicluster/expose-services.yaml