kubectl apply -f namespace.yaml
kubectl label namespace clientns istio-injection=enabled
kubectl apply --recursive -f clients.yaml
kubectl apply --recursive -f istio.yaml
