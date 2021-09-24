#!/bin/bash
export SCRIPT_DIR=`pwd`

echo "Deleting client namespace...Ignore error"
kubectl delete ns clientns --ignore-not-found=true
kubectl create ns clientns
# real api-istio namespace on api cluster
echo "Deleting api namespace...Ignore error"
kubectl delete ns api-istio --ignore-not-found=true
kubectl create ns api-istio

echo "Deleting nonistio namespace...Ignore error"
kubectl delete ns nonistio --ignore-not-found=true
kubectl create ns nonistio

echo "Enable Istio on clientns and api-istio namespace"
kubectl label namespace clientns istio-injection=enabled
kubectl label namespace api-istio istio-injection=enabled

echo "Install api"
cd $SCRIPT_DIR
. $SCRIPT_DIR/setup-api.sh

echo "Install client"
kubectl -n clientns apply -f $SCRIPT_DIR/client.yaml

echo "Install nonistio client"
kubectl -n nonistio apply -f $SCRIPT_DIR/client.yaml
