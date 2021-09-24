echo "Download the required files"
cd $HOME
rm -rf istio-multicluster-gke
git clone https://github.com/GoogleCloudPlatform/istio-multicluster-gke.git

cd $HOME/istio-multicluster-gke
export WORKDIR=$(pwd)

echo "Install kubectx/kubens"
git clone https://github.com/ahmetb/kubectx $WORKDIR/kubectx
export PATH=$PATH:$WORKDIR/kubectx

./cleanup-gke.sh

echo "create the VPCs:"
gcloud compute networks create vpc-client --subnet-mode=auto
gcloud compute networks create vpc-api --subnet-mode=auto

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
    --num-nodes "1" --network "vpc-client" --async

gcloud container clusters create api --zone us-central1-a \
    --machine-type "e2-standard-2" --disk-size "50" \
    --scopes "https://www.googleapis.com/auth/compute",\
"https://www.googleapis.com/auth/devstorage.read_only",\
"https://www.googleapis.com/auth/logging.write",\
"https://www.googleapis.com/auth/monitoring",\
"https://www.googleapis.com/auth/servicecontrol",\
"https://www.googleapis.com/auth/service.management.readonly",\
"https://www.googleapis.com/auth/trace.append" \
    --num-nodes "1" --network "vpc-api"


echo "Verify that the status of the cluster"
gcloud container clusters list

echo "Connect to both clusters to generate entries in the kubeconfig file"
export PROJECT_ID=$(gcloud info --format='value(config.project)')
gcloud container clusters get-credentials client --zone us-west2-a --project ${PROJECT_ID}
gcloud container clusters get-credentials api --zone us-central1-a --project ${PROJECT_ID}

echo "Use kubectx to rename the context names for convenience"
kubectx client=gke_${PROJECT_ID}_us-west2-a_client
kubectx api=gke_${PROJECT_ID}_us-central1-a_api

echo "Give yourself (your Google user) the cluster-admin role for both clusters"
kubectl create clusterrolebinding user-admin-binding \
    --clusterrole=cluster-admin --user=$(gcloud config get-value account) \
    --context client
kubectl create clusterrolebinding user-admin-binding \
    --clusterrole=cluster-admin --user=$(gcloud config get-value account) \
    --context api