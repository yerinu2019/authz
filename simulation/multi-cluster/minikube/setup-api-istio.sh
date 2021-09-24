#!/bin/bash
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
      network: network1
EOF

echo "Apply the configuration to the api cluster"
istioctl install --context=api -y -f istio-api.yaml
