echo "ssh to $1"
kubectl -n clientns exec --stdin --tty $1 -- /bin/bash
