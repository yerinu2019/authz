echo "Deleting client cluster..."
gcloud container clusters delete client --zone us-west2-a -y

echo "Deleting api cluster..."
gcloud container clusters delete api --zone us-central1-a -y

echo "Deleting client network..."
gcloud compute networks delete vpc-client -y

echo "Deleting api network..."
gcloud compute networks delete vpc-api -y