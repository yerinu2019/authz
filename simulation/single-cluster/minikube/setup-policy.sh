#!/bin/bash

kubectl -n api-istio apply -f policy/crd/crd.yaml
kubectl -n api-istio apply -f policy/crd/api1.yaml
kubectl -n api-istio apply -f policy/crd/api2.yaml