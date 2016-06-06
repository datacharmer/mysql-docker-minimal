#!/bin/bash

flavor=$1
version=$2

function get_help
{
    echo "Syntax : $0 flavor version"
    echo "  Where flavor is one of {ubuntu   debian   centos}"
    echo "  And version is one of {5.0   5.1   5.5   5.6   5.7}"
    exit 1
}

if [ -z "$version" ]
then
    get_help
fi

case $flavor in 
    ubuntu)
        echo "# Ubuntu"
        ;;
    debian)
        echo "# Debian"
        ;;
    centos)
        echo "# CentOS"
        ;;
    *)
        echo "Unrecognized flavor $flavor"
        get_help
esac

docker create --name my_bin -v /opt/mysql  datacharmer/mysql-minimal-$version
if [ "$?" != "0" ] ; then exit 1 ; fi
docker run -ti --volumes-from my_bin --name mybox datacharmer/my-$flavor bash

