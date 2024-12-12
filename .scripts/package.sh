#!/bin/bash

cwd=$(pwd)
rootDir=$(git rev-parse --show-toplevel)
infoFile="$rootDir/info.json"

modName=$(jq -r '.name' $infoFile)
if [ -z "$modName" ]; then
    echo "Error: Mod name not found in info.json"
    exit 1
fi

version=$(jq -r '.version' $infoFile)
if [ -z "$version" ]; then
    echo "Error: Mod version not found in info.json"
    exit 1
fi

outputFile="${modName}_${version}.zip"

# git archive --format zip --prefix $modName/ --worktree-attributes --output ./$outputFile HEAD

cd $rootDir
mkdir $modName
cp -r ./*.lua info.json thumbnail.png locale/ LICENSE $modName/
rm -f $outputFile
zip -r $outputFile $modName
rm -rf $modName/

if [ -n "$1" ]; then
    mv $outputFile "$1"
    outputFile="$1/$(basename $outputFile)"
fi

cd $pwd
echo $outputFile
