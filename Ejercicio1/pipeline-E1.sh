#!/bin/bash
set -e

# install deps
deps(){
    go get github.com/gorilla/websocket
    go get github.com/labstack/echo
    sudo pip install requests || true
}

# cleanup
cleanup(){
    pkill votingapp || ps aux | grep votingapp | awk {'print $1'} | head -1 | xargs kill -9
    rm -rf build || true
}

# build 
build(){
    mkdir build
    go build -o ./build ./src/votingapp 
    cp -r ./src/votingapp/ui ./build

    pushd build
        ./votingapp &
    popd

}


# test
test() {
    chmod +x E1.py
    ./E1.py
    
}

deps
cleanup || true
build
test

#./pipeline-E1.sh  && echo “GREN exitCode: $?” || echo “RED exitCode: $?”