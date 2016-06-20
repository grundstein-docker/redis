#!/bin/bash

source ./ENV.sh
source ../../bin/tasks.sh

echo "container: $CONTAINER_NAME"

function build() {
  echo-start "build"

  docker build \
    --tag=$CONTAINER_NAME \
    --build-arg="DIR=$DIR" \
    --build-arg="PORT=$CONTAINER_PORT" \
    . # dot!

  echo-finished "build"
}

function run() {
  remove

  echo-start "run"

  docker run \
    --detach \
    --name $CONTAINER_NAME \
    --volume $DATA_DIR/redis/data:/home/redis/data \
    --publish $HOST_PORT:$CONTAINER_PORT \
    $CONTAINER_NAME

  ip

  echo-finished "run"
}

function help() {
  echo "\
Usage:

./cli.sh $command

commands:
build  - build docker container
run    - run docker container
remove - remove container
logs   - tail the container logs
debug  - connect to container debug session
stop   - stop container
help   - this help text
"
}

if [ $1 ]
then
  function=$1
  shift
  $function $@
else
  help $@
fi

