#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# check if param provided
if [ -z "$1" ]; then
    echo "build-path not provided"
    exit 1
fi

BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
mkdir -p $DIR/tmp

# check if file exists
if [ ! -f $DIR/$1/VERSION ]; then
    echo "No VERSION file found in $DIR/$1"
    exit 1
fi

VERSION=$(awk '{ printf "%s", $0 }' $DIR/$1/VERSION)
echo $VERSION
docker buildx build --build-arg VERSION="jammy-20221101" --file $DIR/$1/Dockerfile .
    # --iidfile /tmp/$1/iidfile  \ 
    # --label org.opencontainers.image.created=$BUILD_DATE  \ 
    # --platform linux/amd64,linux/arm64  \ 
    # --tag ghcr.io/bobrossthepainter/$1:latest  \ 
    # --metadata-file tmp/$1/metadata-file