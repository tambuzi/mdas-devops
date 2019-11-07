#!/bin/bash
set -e 

# cleanup
    docker-compose rm -f || true


# build 
#contruimos y ejecutamos los contenedores   
docker-compose up --build -d


#Generamos los tests
docker-compose run --rm mytest
#devolvemos el código que devuelve el contenedor y elimina el contenedor mytest

#delivery
docker-compose push

#./pipeline-compose.sh  && echo “GREN exitCode: $?” || echo “RED exitCode: $?”