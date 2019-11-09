#!/bin/bash
set -e

#Generamos una nueva red para enlazar los test con la aplicación
docker network create votingapp || true

# cleanup
docker rm -f myvotingapp || true
docker rm -f myredis || true


# build 
docker build -t tambuzi1997/votingapp ./src/votingapp
docker run --network votingapp \
--name myredis \
-d redis

#hacemos que se conecte a la red votingapp
docker run --name myvotingapp \
--network votingapp \
-p 8080:80 \
-e REDIS="myredis:6379" \
-d tambuzi1997/votingapp


#Generamos los tests
docker build -t tambuzi1997/votingapp-test \
./test
#trazamos la ruta de la network sobre la variable VOTINGAPP_HOST
docker run --rm -e VOTINGAPP_HOST="myvotingapp" \
--network votingapp \
tambuzi1997/votingapp-test

#delivery
docker push tambuzi1997/votingapp

#./pipeline-docker.sh  && echo “GREN exitCode: $?” || echo “RED exitCode: $?”