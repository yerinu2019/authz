#!/bin/bash
echo "Make sure that the minikube ingress addon is enabled"
minikube addons enable ingress

echo "Enable opa istio on api-istio namespace"
kubectl label namespace api-istio opa-istio-injection="enabled"

echo "Delete opa-istio namespece"
kubectl delete namespace opa-istio
kubectl create namespace opa-istio

echo "Install OPA envoy filter"
kubectl -n istio-system apply -f opa-envoy-filter.yaml

echo "Install OPA-Envoy"
kubectl apply -f auth-plugin.yaml

echo "Install OPA configmap on api-istio namespace"
kubectl -n api-istio apply -f opa-configmap.yaml

echo "Redeploy api pod"
kubectl -n api-istio rollout restart deployment.apps/api1
kubectl -n api-istio rollout restart deployment.apps/api2
kubectl -n api-istio get all