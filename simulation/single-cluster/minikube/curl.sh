# S1: caller namespace
# S2: caller app label
# $3: called api service
POD=`kubectl -n $1 get pod -l app=$2 -o jsonpath='{.items..metadata.name}'`
echo $POD
kubectl -n $1 exec $POD -- curl -s2 $3
