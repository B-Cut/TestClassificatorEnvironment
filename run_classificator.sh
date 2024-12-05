#!/bin/bash

set -e

if [[ $# == 0 ]]; then
    echo "No repository provided, exiting"
    exit
fi


repo=$1

echo "got $repo"

temp_dir=$(mktemp -d)
original_dir=$(pwd)
cd $temp_dir

echo "changed into $temp_dir, cloning"

git clone --verbose --single-branch git@github.com:$repo.git
echo "finished cloning $repo"

new_folder=$(ls | head)
cd $new_folder
echo "Getting $repo test dependencies..."

groupIds=$(cat $original_dir/libraries.json | jq ".[].libraries.[].groupIds[]" -r | paste -sd,)
mvn dependency:go-offline "-DincludeScope=test" "-DincludeGroupIds=$groupIds" -DskipTests -q

cd ..

echo "Starting classificator for $repo..."
java -jar -Xms3g -Xmx3g $original_dir/HeuristicsClassificator.jar $new_folder $original_dir/keywords.json $original_dir/libraries.json
pid=$!
wait $pid

echo "Finished classifying $repo!"

cp ./results/*.json $original_dir/results/
cd $original_dir
rm -rf $temp_dir
