#!/bin/bash
export SCRIPT_DIR=`pwd`

. $SCRIPT_DIR/install-minikube-mac.sh
. $SCRIPT_DIR/setup-minikube.sh
echo "Minikube setup completed"
. $SCRIPT_DIR/setup-istio.sh
echo "Istio setup completed"
cd $SCRIPT_DIR
. $SCRIPT_DIR/setup-app.sh
echo "Application setup completed"
$SCRIPT_DIR/monitor.sh
echo "Monitor setup completed"