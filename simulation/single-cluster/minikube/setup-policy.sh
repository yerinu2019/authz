#!/bin/bash
echo "load policy rules"
kubectl create configmap policy --from-file=policy/rego/istio/authz/policy.rego -n api-istio --dry-run=client -o yaml | kubectl -n api-istio apply -f -
echo "load policy custom resources"
kubectl -n api-istio apply -f policy/crd/crd.yaml
kubectl -n api-istio apply -f policy/crd/api1/acl.yaml
kubectl -n api-istio apply -f policy/crd/api2/acl.yaml