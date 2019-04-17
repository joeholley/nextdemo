#!/bin/bash
# Slight update to Ilya's cleanup script to include Next Demo headless clients.
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
kubectl delete pod headlessclient 
