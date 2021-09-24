#!/bin/bash
echo "Install Linux minikube"
cd $HOME
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 $HOME
sudo install minikube-linux-amd64 /usr/local/bin/minikube
cd $SCRIPT_DIR
