echo "Create client and api namespace"
kubectl --context client delete ns clientns
kubectl --context client create ns clientns
# real api-istio namespace on api cluster
kubectl --context api  delete ns api-istio
kubectl --context api  create ns api-istio
# stub api-istio namespace on client cluster
kubectl --context client delete ns nonistio
kubectl --context client create ns nonistio

echo "Enable Istio on clientns and api-istio namespace"
kubectl --context client label namespace clientns istio-injection=enabled
kubectl --context api label namespace api-istio istio-injection=enabled

echo "Install api"
cd $SCRIPT_DIR
./setup-api.sh
#kubectl --context api apply -n api-istio -f istio.yaml

echo "Install client"
kubectl --context client -n clientns apply -f $SCRIPT_DIR/client.yaml
#kubectl --context client -n clientns apply -f istio.yaml

echo "Install nonistio client"
kubectl --context client -n nonistio apply -f $SCRIPT_DIR/client.yaml
