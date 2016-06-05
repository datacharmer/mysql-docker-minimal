#!/bin/bash

VERSIONS="$@"
if [ -z "$VERSIONS" ]
then
    VERSIONS=' 5.0.96 5.1.72 5.5.50 5.6.31 5.7.13 '
fi
for VERSION in $VERSIONS
do
    SHORT_VERSION=$(echo $VERSION | perl -pe 's/\.\d+$//')
    if [ -f dbdata/${VERSION}.tar.gz ]
    then
        cd dbdata
        tar -xzf ${VERSION}.tar.gz 
        cd -
    else
        echo "File dbdata/$VERSION.tar.gz not found"
        exit 1
    fi
    if [ ! -d dbdata/${VERSION} ]
    then
        echo "# Directory dbdata/$VERSION not found - aborting"
        exit 1
    fi
    perl -pe "s/__VERSION__/$VERSION/g" Dockerfile.template > Dockerfile
    if [ "$SHORT_VERSION" == "5.7" -o "$SHORT_VERSION" == "ps5.7" ]
    then
        perl -pe "s/__VERSION__/$VERSION/g" install_5_7.sh > dbdata/$VERSION/install.sh
        cp grants_5_7.sql dbdata/$VERSION/grants.sql
    else
        perl -pe "s/__VERSION__/$VERSION/g" install_up_to_5_6.sh > dbdata/$VERSION/install.sh
        cp grants_up_to_5_6.sql dbdata/$VERSION/grants.sql
    fi
    chmod +x dbdata/$VERSION/install.sh
    cp dot_my_cnf dbdata/$VERSION
    IMAGE=datacharmer/mysql-minimal:$SHORT_VERSION
    docker build  -t $IMAGE .
    if [ "$?" != "0" ]
    then
        exit 1
    fi
    rm -rf dbdata/$VERSION
done
