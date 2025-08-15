#!/usr/bin/env zsh

set -eu

DOCKER_PS_RESULT=$(docker ps 2>/dev/null);
BUILDX_NAME=simple-chat-builder

if [[ $DOCKER_PS_RESULT == *running?* ]]; then
  echo "ERROR: docker engine not running. Build failed.";
  exit 1;
fi

PROJECT_ROOT=$(git rev-parse --show-toplevel)

BUILDX_ALREADY_EXISTS=$(docker buildx ls 2>&1 | grep ${BUILDX_NAME}) || true;

if [ -n "${BUILDX_ALREADY_EXISTS}" ]; then
    docker buildx rm ${BUILDX_NAME}
fi

docker login;
docker buildx create --name ${BUILDX_NAME}
docker buildx use ${BUILDX_NAME}

cd ${PROJECT_ROOT}/simple_chat/server
docker buildx build --push --platform=linux/arm64,linux/amd64,linux/s390x,linux/ppc64le --tag doridoridoriand/simple_chat-server:latest --tag doridoridoriand/simple_chat-server:node12.3-v0.0.2 -f Dockerfile .
cd ${PROJECT_ROOT}/simple_chat/client
docker buildx build --push --platform=linux/arm64,linux/amd64,linux/s390x,linux/ppc64le --tag doridoridoriand/simple_chat-client:latest --tag doridoridoriand/simple_chat-client:nginx1.17.4-v0.0.2 -f Dockerfile .