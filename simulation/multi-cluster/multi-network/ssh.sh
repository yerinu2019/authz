POD=`kubectl --context $1 -n $2 get pod -l app=$3 -o jsonpath='{.items..metadata.name}'`
echo "ssh to $1/$2/$POD"
kubectl --context $1 -n $2 exec --stdin --tty $POD -- /bin/bash