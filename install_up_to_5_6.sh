#!/bin/bash

groupadd mysql
useradd -g mysql mysql

EXECDIR=/opt/mysql/__VERSION__

cd /usr/local
ln -s $EXECDIR $PWD/mysql
cd mysql

#if [ -d ./data ]
#then
#    rm -rf data
#fi
#mkdir data
#if [ -d /var/lib/mysql ]
#then
#    mv /var/lib/mysql /var/lib/${$}_mysql
#fi
DATADIR=/var/lib/mysql

./scripts/mysql_install_db --no-defaults --basedir=$PWD --datadir=$DATADIR > out 2>&1

if [ "$?" != "0" ]
then
    cat out
    exit 1
fi

chown -R mysql.mysql $DATADIR

#ln -s $PWD/data /var/lib/mysql

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
