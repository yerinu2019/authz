kubectl --context client apply -f ${HOME}/istio-${ISTIO_VERSION}/samples/addons/prometheus.yaml
kubectl --context client apply -f ${HOME}/istio-${ISTIO_VERSION}/samples/addons/kiali.yaml

kubectl --context client get pods -n istio-system

kubectl --context client port-forward svc/kiali 8080:20001 -n istio-system >> /dev/null &