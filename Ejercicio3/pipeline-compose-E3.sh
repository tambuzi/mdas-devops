#!/bin/bash
set -e 

docker-compose rm -f && \
docker-compose up --build -d && \
docker-compose run --rm mytest && \
docker-compose push && \
echo "GREEN" || echo "RED"


#docker rm -f $(docker ps -qa)
#./pipeline-compose-E3.sh