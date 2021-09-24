#!/bin/bash
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
EOF

echo "Apply the configuration to the client cluster"
istioctl install --context=client -y -f istio-client.yaml
