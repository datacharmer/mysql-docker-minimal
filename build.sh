#!/bin/bash

VERSIONS="$@"
if [ -z "$VERSIONS" ]
then
    VERSIONS=' 4.1.22 5.0.96 5.1.72 5.5.61 5.6.41 5.7.24 8.0.13'
fi
for VERSION in $VERSIONS
do
    SHORT_VERSION=$(echo $VERSION | perl -pe 's/\.\d+$//')
    if [ -f dbdata/${VERSION}.tar.xz ]
    then
        cd dbdata
        tar -xzf ${VERSION}.tar.xz 
        cd -
    else
        echo "File dbdata/$VERSION.tar.xz not found"
        exit 1
    fi
    if [ ! -d dbdata/${VERSION} ]
    then
        echo "# Directory dbdata/$VERSION not found - aborting"
        exit 1
    fi
    perl -pe "s/__VERSION__/$VERSION/g" Dockerfile.template > Dockerfile
    if [ "$SHORT_VERSION" == "5.7" -o "$SHORT_VERSION" == "ps5.7" -o "$SHORT_VERSION" == "8.0" ]
    then
        perl -pe "s/__VERSION__/$VERSION/g" install_5_7.sh > dbdata/$VERSION/install.sh
        cp grants_5_7.sql dbdata/$VERSION/grants.sql
    else
        perl -pe "s/__VERSION__/$VERSION/g" install_up_to_5_6.sh > dbdata/$VERSION/install.sh
        cp grants_up_to_5_6.sql dbdata/$VERSION/grants.sql
    fi
    chmod +x dbdata/$VERSION/install.sh
    cp dot_my_cnf dbdata/$VERSION
    IMAGE=datacharmer/mysql-minimal-$SHORT_VERSION
    docker build  -t $IMAGE .
    if [ "$?" != "0" ]
    then
        exit 1
    fi
    rm -rf dbdata/$VERSION
    rm Dockerfile
done
