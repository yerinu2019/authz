echo "install api deployment to api cluster"
kubectl --context api -n api-istio apply -f api-deployment.yaml
echo "install api service to api cluster"
kubectl --context api -n api-istio apply -f api-service.yaml
echo "install stub api service to client cluster"
kubectl --context client -n api-istio apply -f api-service.yaml