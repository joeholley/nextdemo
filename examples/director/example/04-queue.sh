#!/bin/bash
#
# Copyright 2018 Google LLC
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
  --command ./clientloadgen -- -numplayers 2 -cycles 18 -sleep 5000 1>/dev/null 2>&1 &
read -n 1 -p "Headless clients queuing for matching.  Press enter to monitor Agones autoscaling..."

watch kubectl get fleet udp-server
