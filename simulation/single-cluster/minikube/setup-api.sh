#!/bin/bash

echo "install api deployment to api cluster"
kubectl -n api-istio apply -f $SCRIPT_DIR/api-deployment.yaml
echo "install api service to api cluster"
kubectl -n api-istio apply -f $SCRIPT_DIR/api-service.yaml
