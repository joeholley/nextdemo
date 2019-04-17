# nextdemo

These are the YAML files used for the Open Match and OMAG demos in the Cloud Next 2019 session [Large-Scale Multiplayer Gaming on Kubernetes](https://www.youtube.com/watch?v=Imf_urBB7SI).

## Usage

These files are provided as-is, for reference only. They do not represent best practices or how you should set up an Open Match cluster or anything like that.  They are just the files used in the demo, nothing more, nothing less.  Don't use these if you don't know what they do, and I accept no responsibility for the effects of them if you elect to use them.

## Commands
  
Here is a copy-paste of the commands cheat-sheet referenced while on stage.  This is not a script or a list of things to run in order to get the demo to execute, it's just a list of commands that are useful when using these demo materials in roughly the order they are useful.

```
PS1="$> "

source <(kubectl completion bash)


Demo pt1

gcloud container clusters get-credentials om-demo --zone us-west2-b

kubectl get all

gcloud container images list

kubectl create configmap om-configmap-debug-off \
  --from-file=config/om-configmap-debug-off.yaml

kubectl apply -f install/yaml/01-redis.yaml

kubectl apply -f install/yaml/02-open-match.yaml

kubectl get all

kubectl run --rm --restart=Never --image-pull-policy=Always \
   -i --tty --image=gcr.io/omag-demo/openmatch-clientloadgen:nextdemo \
  headlessclientgenerator --command ./clientloadgen -- \
  --cycles 7 --numplayers 10000 --sleep 1

kubectl run --rm --restart=Never --image-pull-policy=Always \
  -i --tty --image=gcr.io/omag-demo/openmatch-matchmaker:nextdemo \
  matchmaker --command /bin/bash

./matchmaker --call CreateMatch --concurrency 2

./matchmaker --call CreateMatch --concurrency 20

exit


Demo pt2
gcloud container clusters get-credentials test-cluster --zone us-west2-b

# Show components from previous demo
kubectl get all

# Deploy an Agones Fleet
kubectl apply -f examples/director/example/01-fleet.yaml

# Deploy a matchmaker that speaks OMAG
kubectl apply -f examples/director/example/03-director-deploy.yaml

# Explain udp-server, create two users, create many more
examples/director/example/04-queue.sh


# Cleanup
./examples/director/example/00-cleanup.sh


Debugging
gcloud config set project omag-demo

gcloud --quiet container clusters delete om-demo --zone=us-west2-b

gcloud container clusters create --machine-type n1-standard-4 om-demo --zone us-west2-b

git clone https://github.com/joeholley/nextdemo.git 
cd nextdemo

kubectl run --rm --restart=Never --image-pull-policy=Always -i --tty --image=redis rcli2 --command redis-cli -- -h redis

./examples/director/example/00-cleanup.sh
```
