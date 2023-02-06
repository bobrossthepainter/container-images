#!/usr/bin/env bash

item=library/ubuntu

tokenUri="https://auth.docker.io/token"
data=("service=registry.docker.io" "scope=repository:$item:pull")
token="$(curl --silent --get --data-urlencode ${data[0]} --data-urlencode ${data[1]} $tokenUri | jq --raw-output '.token')"
listUri="https://registry-1.docker.io/v2/$item/tags/list"
authz="Authorization: Bearer $token"
# result="$(curl --silent --get -H "Accept: application/json" -H "Authorization: Bearer $token" $listUri | jq --raw-output '.')"
# echo $result


version=$(curl -s -H "Authorization: Bearer $token" $listUri | jq --raw-output ' .tags[] | select( contains("jammy") )' | tail -n1)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"