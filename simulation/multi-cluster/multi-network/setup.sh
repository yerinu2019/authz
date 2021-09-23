echo "Download the required files"
cd $HOME
git clone https://github.com/GoogleCloudPlatform/istio-multicluster-gke.git

cd $HOME/istio-multicluster-gke
WORKDIR=$(pwd)

echo "Install kubectx/kubens"
git clone https://github.com/ahmetb/kubectx $WORKDIR/kubectx
export PATH=$PATH:$WORKDIR/kubectx

echo "create the VPCs:"
#gcloud compute networks create vpc-west --subnet-mode=auto
#gcloud compute networks create vpc-central --subnet-mode=auto

echo "Set the KUBECONFIG variable to use a new kubeconfig file"
export KUBECONFIG=${WORKDIR}/istio-kubeconfig

echo "Create two GKE clusters"
gcloud container clusters create client --zone us-west2-a \
    --machine-type "e2-standard-2" --disk-size "50" \
    --scopes "https://www.googleapis.com/auth/compute",\
"https://www.googleapis.com/auth/devstorage.read_only",\
"https://www.googleapis.com/auth/logging.write",\
"https://www.googleapis.com/auth/monitoring",\
"https://www.googleapis.com/auth/servicecontrol",\
"https://www.googleapis.com/auth/service.management.readonly",\
"https://www.googleapis.com/auth/trace.append" \
    --num-nodes "1" --network "vpc-west" --async

gcloud container clusters create api --zone us-central1-a \
    --machine-type "e2-standard-2" --disk-size "50" \
    --scopes "https://www.googleapis.com/auth/compute",\
"https://www.googleapis.com/auth/devstorage.read_only",\
"https://www.googleapis.com/auth/logging.write",\
"https://www.googleapis.com/auth/monitoring",\
"https://www.googleapis.com/auth/servicecontrol",\
"https://www.googleapis.com/auth/service.management.readonly",\
"https://www.googleapis.com/auth/trace.append" \
    --num-nodes "1" --network "vpc-central"

./setup2.sh