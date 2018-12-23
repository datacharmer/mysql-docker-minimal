#!/bin/bash
for F in $(cat push.txt)
do
    docker push $F
done
