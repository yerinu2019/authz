echo "ssh to $1/$2/$3"
kubectl --context $1 -n $2 exec --stdin --tty $3 -- /bin/bash
