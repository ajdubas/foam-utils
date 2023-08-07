#!/bin/bash

# Make OpenFOAM directory
mkdir -p $HOME/OpenFOAM
cd $HOME/OpenFOAM

# Get source files
wget -O - http://dl.openfoam.org/source/11 | tar -xvz
mv OpenFOAM-11-version-11 OpenFOAM-11
wget -O - http://dl.openfoam.org/third-party/11 | tar -xvz
mv ThirdParty-11-version-11 ThirdParty-11

# Set environment variables
source $HOME/OpenFOAM/OpenFOAM-11/etc/bashrc

# Build ThirdParty software
cd ThirdParty-11
./Allwmake
cd ..

# Build OpenFOAM
cd OpenFOAM-11
sed -i 's/-O3/-O3 -march=native -mtune=native/g' wmake/rules/$WM_ARCH$WM_COMPILER/*Opt
./Allwmake
cd ..

# Make run directory
mkdir -p $FOAM_RUN
