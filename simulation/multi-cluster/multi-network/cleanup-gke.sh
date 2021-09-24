echo "Deleting client cluster..."
gcloud container clusters delete client --zone us-west2-a -q

echo "Deleting api cluster..."
gcloud container clusters delete api --zone us-central1-a -q

echo "Deleting client network..."
gcloud compute networks delete vpc-client -q

echo "Deleting api network..."
gcloud compute networks delete vpc-api -q