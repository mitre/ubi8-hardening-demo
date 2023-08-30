#!/bin/bash

if $PUSH_TO_REGISTRY
then
    docker push $DOCKER_REGISTRY/$TARGET_IMAGE:passed
    exit $?
else 
    exit 0
fi   