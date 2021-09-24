#!/bin/bash
echo "Stop and delete minikube clusters...ignore errors"
minikube stop --profile client
minikube stop --profile api

minikube delete --profile client
minikube delete --profile api

echo "Create minikube clusters"
minikube start --memory 8192 --cpus 4 --profile client
minikube start --memory 8192 --cpus 4 --profile api