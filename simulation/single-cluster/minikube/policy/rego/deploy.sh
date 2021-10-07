#!/bin/bash

#echo "build"
#opa build -b .
#echo "upload"
#gsutil cp -p bundle.tar.gz gs://test-opa-policy-bundles
echo "load configmap"
kubectl create configmap policy --from-file=istio/authz/policy.rego -n api-istio --dry-run=client -o yaml | kubectl -n api-istio apply -f -
echo "restart pods"
kubectl -n api-istio rollout restart deployment api1
kubectl -n api-istio rollout restart deployment api2
echo "check pod"
kubectl -n api-istio get pod