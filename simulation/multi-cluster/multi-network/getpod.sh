kubectl --context $1 get pod -l app=$3 -o jsonpath='{.items..metadata.name}' -n $2
