#!/bin/bash
# el path superior define el lenguaje del scrip
set -e

# install dep
#instalamos las dependencias
install() {
    go get github.com/gorilla/websocket
    go get github.com/labstack/echo
}

# cleanup del directorio build
cleanup() {
    #pkill votingapp || ps aux | grep votingapp | awk {'print $1'} | head -1 | xargs kill -9
    docker rm -f votingapp
    rm -rf build || true
}

# build
build() {
    mkdir build # creamos el directorio build
    go build -o ./build ./src/votingapp
    cp -r ./src/votingapp/ui ./build

    #pushd build
    #./votingapp &
    docker run --name myvotingapp -v $(pwd)/build:/app -w /app -p 8080:80 -d ubuntu ./votingapp #lanzamos la aplicación directamente en el contendedor
    #popd
}

#Retry system
retry() {
    n=0
    interval=5
    retries=3
    $@ && return 0
    until [ $n -ge $retries ]; do
        n=$(($n + 1))
        echo "Retrying...$n of $retries, wait for $interval seconds"
        sleep $interval
        $@ && return 0
    done

    return 1
}

# test
test() {
    votingurl='http://localhost:8080/vote'
    
    curl --url  $votingurl \
        --request POST \
        --data '{"topics":["dev", "ops"]}' \
        --header "Content-Type: application/json" 

    curl --url $votingurl \
        --request PUT \
        --data '{"topic": "dev"}' \
        --header "Content-Type: application/json" 
    
    winner=$(curl --url $votingurl \
        --request DELETE \
        --header "Content-Type: application/json" | jq -r '.winner')

    echo "Winner IS "$winner

    expectedWinner="dev"

    if [ "$expectedWinner" == "$winner" ]; then
        echo 'TEST PASSED'
        return 0
    else
        echo 'TEST FAILED'
        return 1
    fi
}

install
cleanup
GOOS=linux build #compilamos con linux el build
retry test

#./pipeline-docker.sh  && echo “GREN exitCode: $?” || echo “RED exitCode: $?”
