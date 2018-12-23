#!/bin/bash
[ -z "$FLAVORS" ] && FLAVORS="debian ubuntu centos"
[ -z "$VERSIONS" ] && VERSIONS="4.1 5.0 5.1 5.5 5.6 5.7 8.0"
for F in $FLAVORS
do  
    for V in $VERSIONS
    do 
        ./deploy-test.sh $F $V 
        exit_code=$?
        remove_containers.sh 
        if [ "$exit_code" != "0" ]
        then
            echo "Error testing $V on $F"
            exit $exit_code
        fi
    done 
done
