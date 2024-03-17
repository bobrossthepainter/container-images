#!/usr/bin/env bash

set -e

echo "input arch is ${TARGETARCH}..."
if test ${TARGETARCH} = "amd64" ; then
    export PLATFORM_ARCH="x86_64"
elif test ${TARGETARCH} = "arm64" ; then
    export PLATFORM_ARCH="aarch64"
fi
echo "...using ${PLATFORM_ARCH}"

mkdir -p /opt
curl -qL https://download.docker.com/linux/static/stable/${PLATFORM_ARCH}/docker-23.0.4.tgz | tar xvz -C /opt
ln -s /opt/docker/docker /usr/local/bin/docker
