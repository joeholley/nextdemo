#!/bin/bash
#set -x
# Headless client
kubectl run --rm --restart=Never --image-pull-policy=Always \
  -i --tty --image=gcr.io/omag-demo/openmatch-clientloadgen:nextdemo headlessclient \
  --command ./clientloadgen -- -numplayers 1 -cycles 1 -sleep 1
kubectl delete pod headlessclient 2>/dev/null &
read -n 1 -p "Headless client queued for matching.  Press enter to continue..."

# Real client
kubectl run --rm --restart=Never --image-pull-policy=Always \
  -i --tty --image=gcr.io/omag-demo/openmatch-frontendclient:nextdemo udp-client \
  --command ./frontendclient -- -numplayers 1 -connect
kubectl delete pod udp-client 2>/dev/null  &

# Headless clients forever, show it autoscaling
kubectl run --rm --restart=Never --image-pull-policy=Always \
  -i --tty --image=gcr.io/omag-demo/openmatch-clientloadgen:nextdemo headlessclient \
  --command ./clientloadgen -- -numplayers 2 -cycles 18 -sleep 5000 2>/dev/null &

watch kubectl get fleet udp-server

kubectl delete pod headlessclient 2>/dev/null &
