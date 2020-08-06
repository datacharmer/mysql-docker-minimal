#!/bin/bash
for F in $(cat push.txt | grep -v '^#' )
do
    docker push $F
done
