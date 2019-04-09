#!/bin/sh
set -x
kubectl delete $(kubectl get deploy om-director -o name)
kubectl delete $(kubectl get fleet -o name)
kubectl delete $(kubectl get fleetautoscaler -o name)
for job in `kubectl get jobs --no-headers | awk '{print $1}'`; do
    kubectl delete jobs ${job} &
done
kubectl run --rm --restart=Never --image-pull-policy=Always \
 -i --tty --image=redis rclean \
  --command redis-cli -- -h redis FLUSHALL
