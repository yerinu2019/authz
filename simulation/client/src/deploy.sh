echo "delete client deployments"
kubectl -n clientns delete deployment client1
kubectl -n clientns delete deployment client2
echo "delete client image in minikube"
minikube image rm docker.io/client/osltest:latest
echo "delete docker image"
docker rmi -f client/osltest
echo "build docker image"
docker build -t client/osltest .
echo "load new client image to minikube"
minikube image load client/osltest
echo "start client deployments"
kubectl apply -f ../clients.yaml
kubectl apply -f ../istio.yaml