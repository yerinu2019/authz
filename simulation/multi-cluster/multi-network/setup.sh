#!/bin/bash
export SCRIPT_DIR=`pwd`
#export PATH=$PATH:$SCRIPT_DIR
$SCRIPT_DIR/setup-gke.sh
echo "GKE setup completed"

cd $SCRIPT_DIR
$SCRIPT_DIR/setup-istio.sh
echo "Istio setup completed"

. $SCRIPT_DIR/setup-app.sh $SCRIPT_DIR
echo "Application setup completed"

$SCRIPT_DIR/monitor.sh
echo "Monitor setup completed"