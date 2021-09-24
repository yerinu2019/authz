cd ${WORKDIR}
export ISTIO_VERSION=1.11.2

echo "delete Istio"
rm -rf istio-${ISTIO_VERSION}

echo "download Istio"
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

$SCRIPT_DIR/setup-client-istio.sh
$SCRIPT_DIR/setup-api-istio.sh

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