#!/bin/sh

git clone --depth 1 -b 4.27 https://github.com/EpicGames/UnrealEngine

cd UnrealEngine

./Setup.sh
./GenerateProjectFiles.sh
make

echo "Unreal Engine Setup is Done"
