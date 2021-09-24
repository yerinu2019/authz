# $1: caller cluster
# S2: caller namespace
# S3: caller app label
# $5: called api service
POD=`kubectl --context $1 -n $2 get pod -l app=$3 -o jsonpath='{.items..metadata.name}'`
echo $POD
kubectl --context $1 -n $2 exec $POD -- curl -sS $4
