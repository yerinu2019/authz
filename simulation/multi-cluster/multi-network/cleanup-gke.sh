echo "Delete client cluster"
gcloud container clusters delete client

echo "Delete api cluster"
gcloud container clusters delete api

echo "Delete client network"
gcloud compute networks delete vpc-client

echo "Delete api network"
gcloud compute networks delete vpc-api