#!/bin/bash

# set -x
set -e

VIPS_VERSION=8.13.3
docker build --progress plain --build-arg VIPS_VERSION=${VIPS_VERSION} -t libvips-heroku22 container 2>&1 | tee build/output.log.txt # uncomment this for testing (if helpful)
#docker build --no-cache --build-arg VIPS_VERSION=${VIPS_VERSION} -t libvips-heroku22 container

mkdir -p build

docker run --rm -t -v $PWD/build:/data libvips-heroku22 sh -c 'cp -f /usr/src/vips/build/*.tar.gz /data/'
