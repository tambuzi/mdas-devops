###### BUILDER ######
FROM golang:alpine AS builder

COPY . .

#Cada RUN genera un layer nuevo en Docker

#Instalamos dependencias
#Instalamos git y limpiamos la caché 
RUN apk update && apk add --no-cache git && \
rm -rf /var/cache/apk/*

RUN go get github.com/labstack/echo && \
    go get github.com/gorilla/websocket && \
    go get github.com/go-redis/redis

#Generamos el build
RUN go build -o /build/votingapp && \
    cp -r ui /build


###### RUNTIME ######
FROM alpine

WORKDIR /app
#importamos la carpeta build desde el stage bulder (generado al inicio del documento)
COPY --from=builder /build .


ENTRYPOINT [ "./votingapp" ]