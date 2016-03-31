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
  echo "Container: $CONTAINER_NAME"
  echo ""
  echo "Usage:"
  echo ""
  echo './cli.sh $command'
  echo ""
  echo "commands:"
  echo "build  - build docker container"
  echo "run    - run docker container"
  echo "remove - remove container"
  echo "logs   - tail the container logs"
  echo "debug  - connect to container debug session"
  echo "stop   - stop container"
  echo "help   - this help text"
}

if [ $1 ]
then
  function=$1
  shift
  $function $@
else
  help $@
fi

