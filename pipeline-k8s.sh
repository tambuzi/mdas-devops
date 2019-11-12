#!/bin/bash

docker-compose rm -f && \
docker-compose up --build -d && \
docker-compose run --rm mytest && \
docker-compose push && \
echo "GREEN" || echo "RED"

# deploy
kubectl apply -f votingapp.yaml && \
kubectl run mytests \
    --generator=run-pod/v1 \
    --image=tambuzi1997/votingapp-test \
    --env VOTINGAPP_HOST=myvotingapp.votingapp \
    --rm --attach --restart=Never && \
echo "GREEN" || echo "RED"

#./pipeline-k8s.sh