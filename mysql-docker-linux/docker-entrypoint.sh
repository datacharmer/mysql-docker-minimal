#!/bin/bash

if [ -x /opt/mysql/install.sh ]
then
    /opt/mysql/install.sh
    echo 'export PATH=/usr/local/mysql/bin:$PATH' >> $HOME/.bashrc
fi

if [ ! -d $HOME/opt/mysql ]
then
    mkdir -p $HOME/opt/mysql
fi

"$@"
