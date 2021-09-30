#!/bin/bash

echo "Enable opa istio on api-istio namespace"
kubectl label namespace api-istio opa-istio-injection="enabled"

echo "Install OPA-Envoy"
kubectl apply -f auth-plugin.yaml

echo "Install OPA configmap on api-istio namespace"
kubectl -n api-istio apply -f opa-configmap.yaml