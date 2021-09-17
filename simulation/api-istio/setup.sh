kubectl apply -f namespace.yaml
kubectl label namespace api-istio istio-injection=enabled
kubectl apply --recursive -f apis.yaml
kubectl apply --recursive -f istio.yaml
