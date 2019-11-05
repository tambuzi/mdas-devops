#!/bin/bash
set -e

#Generamos una nueva red para enlazar los test con la aplicación
docker network create votingapp || true

# cleanup
    docker rm -f myvotingapp || true


# build 
    docker build -t tambuzi1997/votingapp ./src/votingapp
        #hacemos que se conecte a la red votingapp
    docker run --name myvotingapp \
    --network votingapp \
    -p 8080:80 \
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