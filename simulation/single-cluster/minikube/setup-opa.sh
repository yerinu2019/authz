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

echo "Install policy crd"
kubectl -n api-istio apply -f policy/crd/crd.yaml

echo "Install kubemgmt"
kubectl -n api-istio apply -f policy/kube-mgmt/load.yaml

echo "Install crd policies"
kubectl -n api-istio apply -f policy/crd/api1/acl.yaml
kubectl -n api-istio apply -f policy/crd/api2/acl.yaml

echo "Install OPA-Envoy"
kubectl apply -f auth-plugin.yaml

echno "Install Egress Gateway"
kubectl -n api-istio apply -f egress.yaml

echo "Install OPA configmap on api-istio namespace"
kubectl -n api-istio apply -f opa-configmap.yaml

echo "Redeploy api pod"
kubectl -n api-istio rollout restart deployment.apps/api1
kubectl -n api-istio rollout restart deployment.apps/api2
kubectl -n api-istio get all