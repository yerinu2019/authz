#!/bin/bash
export SCRIPT_DIR=`pwd`

echo "Deleting client namespace...Ignore error"
kubectl --context client delete ns clientns --ignore-not-found=true
kubectl --context client create ns clientns
# real api-istio namespace on api cluster
echo "Deleting api namespace...Ignore error"
kubectl --context api  delete ns api-istio --ignore-not-found=true
kubectl --context api  create ns api-istio
# stub api-istio namespace on client cluster
echo "Deleting nonistio namespace...Ignore error"
kubectl --context client delete ns nonistio --ignore-not-found=true
kubectl --context client create ns nonistio

echo "Enable Istio on clientns and api-istio namespace"
kubectl --context client label namespace clientns istio-injection=enabled
kubectl --context api label namespace api-istio istio-injection=enabled

echo "Install api"
cd $SCRIPT_DIR
. $SCRIPT_DIR/setup-api.sh

echo "Install client"
kubectl --context client -n clientns apply -f $SCRIPT_DIR/client.yaml

echo "Install nonistio client"
kubectl --context client -n nonistio apply -f $SCRIPT_DIR/client.yaml
