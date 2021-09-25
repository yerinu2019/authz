#!/bin/bash

# Download istio-multicluster-gke to use cert files
echo "Delete and download istio-multicluster-gke.git"
cd $HOME
rm -rf istio-multicluster-gke
git clone https://github.com/GoogleCloudPlatform/istio-multicluster-gke.git

cd $HOME/istio-multicluster-gke
export WORKDIR=$(pwd)

cd ${WORKDIR}
export ISTIO_VERSION=1.11.2

echo "delete Istio"
rm -rf istio-${ISTIO_VERSION}

echo "download Istio"
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=x86_64 sh -
cd istio-${ISTIO_VERSION}
export PATH=$PWD/bin:$PATH

echo "Apply the configuration to the client cluster"
istioctl install --set profile=demo -y
