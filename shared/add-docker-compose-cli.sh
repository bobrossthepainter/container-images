#!/usr/bin/env bash

set -e

echo "input arch is ${TARGETARCH}..."
if test ${TARGETARCH} = "amd64" ; then
    export PLATFORM_ARCH="x86_64"
elif test ${TARGETARCH} = "arm64" ; then
    export PLATFORM_ARCH="aarch64"
fi
echo "...using ${PLATFORM_ARCH}"

export DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}

mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.17.3/docker-compose-linux-${PLATFORM_ARCH} -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
