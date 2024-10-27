#!binsh

git clone -b 4.27 httpsgithub.comEpicGamesUnrealEngine

cd UnrealEngine

.Setup.sh

.GenerateProjectFiles.sh

make

echo Unreal Engine Setup is Done