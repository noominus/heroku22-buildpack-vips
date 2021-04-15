#!/bin/bash

# set -x
set -e

VIPS_VERSION=8.10.6
docker build --progress plain --build-arg VIPS_VERSION=${VIPS_VERSION} -t libvips-heroku20 container # uncomment this for testing (if helpful)
#docker build --no-cache --build-arg VIPS_VERSION=${VIPS_VERSION} -t libvips-heroku20 container

mkdir -p build

docker run --rm -t -v $PWD/build:/data libvips-heroku20 sh -c 'cp -f /usr/src/vips/build/*.tar.gz /data/'
