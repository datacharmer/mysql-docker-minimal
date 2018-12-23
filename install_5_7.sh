#!/bin/bash

groupadd mysql
useradd -g mysql mysql

EXECDIR=/opt/mysql/__VERSION__

echo "Installing MySQL __VERSION__ ..."
cd /usr/local
ln -s $EXECDIR $PWD/mysql
cd mysql

DATADIR=/var/lib/mysql
export LD_LIBRARY_PATH=/usr/local/mysql/lib:/usr/lib:/usr/lib64:/lib:/lib64:$EXECDIR/lib
./bin/mysqld --no-defaults --initialize-insecure --basedir=$PWD --datadir=$DATADIR > out 2>&1

if [ "$?" != "0" ]
then
    cat out
    exit 1
fi

chown -R mysql.mysql $DATADIR


./bin/mysqld_safe --basedir=$PWD --datadir=$DATADIR --user=mysql --log-error=/var/log/mysqld.log > /dev/null 2>&1 & 

TIMEOUT=30
ELAPSED=0
while [ ! -e /tmp/mysql.sock ]
do
    echo -n '.'
    sleep 1
    ELAPSED=$(($ELAPSED+1))
    if [[ $ELAPSED -gt $TIMEOUT ]]
    then
        echo ''
        echo "# Timeout $TIMEOUT seconds used up"
        exit 1
    fi 
done
echo ''
./bin/mysql < $EXECDIR/grants.sql

echo 'export PATH=/usr/local/mysql/bin:$PATH' > /etc/profile.d/mysql.sh
cp $EXECDIR/dot_my_cnf $HOME/.my.cnf
if [ -z "$SKIP_CLIENT" ]
then
    /usr/local/mysql/bin/mysql
fi
