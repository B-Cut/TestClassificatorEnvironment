#!/bin/bash

# This script runs the test classificator program on multiple processes

# Get JSON
# Get a file based on process number

if [[ $# == 0 ]]; then 
    echo "usage: $0 <repositories.json>"
    exit
fi

repos=$1

run_docker_classificator(){
    repo=$1
    echo "Got $repo"
    image_name="cgoncalves/test-classificator"
    docker run --memory=4g --mount type=bind,source="./results",destination="/classify/results" -a STDOUT -a STDERR --rm cgoncalves/test-classificator "$repo"
}

export -f run_docker_classificator

docker_image_name="cgoncalves/test-classificator"

jq -r ".[] | .repo" $repos | parallel -j3 -u "run_docker_classificator"
