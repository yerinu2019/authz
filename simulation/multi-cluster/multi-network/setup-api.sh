#!/bin/bash

echo "install api deployment to api cluster"
kubectl --context api -n api-istio apply -f $SCRIPT_DIR/api-deployment.yaml
echo "install api service to api cluster"
kubectl --context api -n api-istio apply -f $SCRIPT_DIR/api-service.yaml

echo "Not installing api stub in client. Run $SCRIPT_DIR/api-stub.sh if not working"
# echo "Install api stub in client"
# $SCRIPT_DIR/api-stub.sh