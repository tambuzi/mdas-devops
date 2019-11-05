###### BUILDER ######
FROM golang AS builder

COPY . .

#Cada RUN genera un layer nuevo en Docker

#Instalamos dependencias
RUN go get github.com/labstack/echo && \
    go get github.com/gorilla/websocket

#Generamos el build
RUN go build -o /build/votingapp && \
    cp -r ui /build


###### RUNTIME ######
FROM ubuntu:18.04 

WORKDIR /app
#importamos la carpeta build desde el stage bulder (generado al inicio del documento)
COPY --from=builder /build .


ENTRYPOINT [ "./votingapp" ]