#!/bin/bash

FLAVORS=$1

if [ -z "$FLAVORS" ]
then
    FLAVORS='ubuntu debian centos'
fi

for FLAVOR in $FLAVORS
do
    OLD_IMAGE=$(docker images | grep "datacharmer/my-$FLAVOR" | awk '{print $3}' )
    if [ -n "$OLD_IMAGE" ]
    then
        docker rmi $OLD_IMAGE
    fi
    if [ -f Dockerfile.$FLAVOR ]
    then
        cp Dockerfile.$FLAVOR Dockerfile
    else
        echo "# Flavor $FLAVOR not found"
        exit 1
    fi
    docker build -t datacharmer/my-$FLAVOR . 
done
