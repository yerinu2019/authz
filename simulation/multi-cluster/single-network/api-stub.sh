echo "create api stub namespace in client cluster"
kubectl --context client delete ns api-istio
kubectl --context client create ns api-istio

kubectl --context client label namespace api-istio istio-injection=enabled

echo "install stub api service to client cluster"
kubectl --context client -n api-istio apply -f api-service.yaml