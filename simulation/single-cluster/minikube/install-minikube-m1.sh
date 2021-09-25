#!/bin/bash
echo "Install Mac minikube"
cd $HOME
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-arm64
sudo install minikube-darwin-arm64 /usr/local/bin/minikube
cd $SCRIPT_DIR
