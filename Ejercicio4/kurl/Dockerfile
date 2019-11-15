FROM ubuntu:18.04
#Declaramos la versión de uso de ubuntu para evitar actualizaciones

RUN apt-get update && apt-get install curl -y && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "curl" ] 
#Evitamos tener que ejecutar curl dentro del build

#docker build -f kurl/Dockerfile -t tambuzi1997/kurl:1.0 .
#Comando superior para ejecutar o acutualizar el build

#docker run tambuzi1997/kurl:1.0 google.com