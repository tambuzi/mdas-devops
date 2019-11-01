FROM ubuntu:18.04
#Declaramos la versión de uso de ubuntu para evitar actualizaciones

WORKDIR /app
COPY build .
#entramos dentro de la carpeta app y copiamos allí todo el contenido de la carpeta local build

ENTRYPOINT [ "./votingapp" ]

