#!/bin/bash
# el path superior define el lenguaje del scrip
set -e

# install dep
#instalamos las dependencias
go get github.com/gorilla/websocket
go get github.com/labstack/echo

# cleanup del directorio build
rm -rf build || true
pkill votingapp || ps aux | grep votingapp | awk {'print $?'} | head -1 | xargs kill -9

# build 
build () {
    mkdir build # creamos el directorio build
    go build -o ./build ./src/votingapp
    cp -r ./src/votingapp/ui ./build
}

pushd build
./votingapp &
popd

# test
test() {
    curl --url http://localhost/vote \
    --request POST \
    --data '{"topics": ["dev", "ops"]}' \
    --header "Content-Type: application/json"

    curl --url http://localhost/vote \
    --request PUT \
    --data '{"topics": "dev"}' \
    --header "Content-Type: application/json"

    winner=$(curl --url http://localhost/vote \
    --request DELETE \
    --header "Content-Type: application/json" | jq -r '.winner')

    echo"Winner is " $Winner
    expectedWinner="dev"

    if [ "$expectedWinner" == "$winner" ]; then
        echo 'TEST PASSED'
        return 0
    else
        echo 'TEST FAILED'
        return 1
    fi
}

build
test


#./pipeline.sh  && echo “GREN exitCode: $?” || echo “RED exitCode: $?”