#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# automatically increment fix version
file="$DIR/IMAGE_VERSION"
read -d $'\x04' version < "$file"
IFS=. read -r major minor fix <<< $version
let fix+=1
version="$major.$minor.$fix"

printf "%s" "${version}"
