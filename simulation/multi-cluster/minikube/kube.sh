echo "Use minikube to start two kubernetes cluster named cluster1 and cluster2."
minikube start --kubernetes-version='1.22.0' --memory 8192 --cpus 4 --profile cluster1
minikube start --kubernetes-version='1.22.0' --memory 8192 --cpus 4 --profile cluster2