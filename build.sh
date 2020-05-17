#!/bin/bash

git clone https://github.com/swagger-api/swagger-codegen.git repository
cd repository 
git fetch --all --tags --prune
git checkout tags/v2.4.14 -b master
cp -r ../modules ./
./run-in-docker.sh mvn clean package
