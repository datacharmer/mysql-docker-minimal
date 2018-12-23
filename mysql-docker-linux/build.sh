#!/bin/bash

for ps in $(docker ps -a ) 
do
    for F in $(cat push.txt)
    do
        if [ $ps == $F ]
        then
            echo "$F is running"
            should_exit=1
        fi    
    done
done

if [ -n "$should_exit" ]
then
    exit 1
fi

cd $(dirname $0)
FLAVORS=$1

cp $HOME/go/bin/dbdeployer .
if [ "$?" != "0" ] ; then exit ; fi
cp /etc/bash_completion.d/dbdeployer_completion.sh .
if [ "$?" != "0" ] ; then exit ; fi

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
