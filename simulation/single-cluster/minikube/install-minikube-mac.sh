#!/bin/bash
echo "Install Mac minikube"
cd $HOME
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
cd $SCRIPT_DIR
