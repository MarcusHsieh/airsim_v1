#!/bin/bash
set -x

if ! which unzip; then
    sudo apt-get install unzip
fi

wget -c https://github.com/microsoft/AirSim/releases/download/v1.8.1/AirSimNH.zip
unzip -q AirSimNH.zip
rm AirSimNH.zip

wget -c https://github.com/microsoft/AirSim/releases/download/v1.8.1/Blocks.zip
unzip -q Blocks.zip
rm Blocks.zip