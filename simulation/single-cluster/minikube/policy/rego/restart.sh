#!/bin/bash
echo "restart pods"
kubectl -n api-istio rollout restart deployment api1
kubectl -n api-istio rollout restart deployment api2
echo "check pod"
kubectl -n api-istio get pod