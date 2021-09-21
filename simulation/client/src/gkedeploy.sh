docker build -t client/osltest .
echo "load new client image to minikube"
docker tag client/osltest gcr.io/monorepotest-323514/oslclient
docker push gcr.io/monorepotest-323514/oslclient
