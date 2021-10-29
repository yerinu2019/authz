#!/bin/bash
echo "Create minikube clusters"
minikube start --driver docker --memory 16000 --cpus 4

./setup-app.sh
kubectl -n api-istio get po