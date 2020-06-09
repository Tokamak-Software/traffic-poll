#!/bin/sh
mkdir bin
BUILD_DOCKER_NAME=tokamak-software/traffic-stream:build
echo "Building $BUILD_DOCKER_NAME"
docker build . -f Dockerfile.build -t $BUILD_DOCKER_NAME
docker container create --name extract $BUILD_DOCKER_NAME
docker container cp extract:/go/src/github.com/tokamak-software/traffic-stream/poller ./bin/traffic-poller
docker container rm -f extract

DOCKER_NAME=traffic-stream:latest
echo "Building $DOCKER_NAME"
docker build --no-cache -t $DOCKER_NAME .
