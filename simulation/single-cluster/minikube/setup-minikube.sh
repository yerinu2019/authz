#!/bin/bash
echo "Stop and delete minikube clusters...ignore errors"
minikube stop
minikube delete

echo "Create minikube clusters"
minikube start --driver docker --memory 8192 --cpus 4