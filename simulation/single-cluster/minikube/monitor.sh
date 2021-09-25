kubectl apply -f ${HOME}/istio-${ISTIO_VERSION}/samples/addons/prometheus.yaml
kubectl apply -f ${HOME}/istio-${ISTIO_VERSION}/samples/addons/kiali.yaml

kubectl get pods -n istio-system

kubectl port-forward svc/kiali 8080:20001 -n istio-system >> /dev/null &

echo "Open the Kiali web interface on the client cluster. In Cloud Shell, select Web Preview, and then select Preview on port 8080."
echo "From the left menu, select Graph."
echo "From the Select a namespace drop-down list, select clientns."
echo "From the menu under Graph, select Service graph."
echo "Optionally, from the Display menu, select Traffic Animation"
echo ""