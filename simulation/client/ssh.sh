echo "ssh to $1"
kubectl -n $2 exec --stdin --tty $1 -- /bin/bash
