#!/bin/bash

# Make OpenFOAM directory
mkdir -p $HOME/OpenFOAM
cd $HOME/OpenFOAM

# Get source files
wget -O - http://dl.openfoam.org/source/8 | tar -xvz
mv OpenFOAM-8-version-8 OpenFOAM-8
wget -O - http://dl.openfoam.org/third-party/8 | tar -xvz
mv ThirdParty-8-version-8 ThirdParty-8

# Set environment variables
source $HOME/OpenFOAM/OpenFOAM-8/etc/bashrc

# Build ThirdParty software
cd ThirdParty-8
./Allwmake
cd ..

# Build OpenFOAM
cd OpenFOAM-8
sed -i 's/-O3/-O3 -march=native -mtune=native/g' wmake/rules/$WM_ARCH$WM_COMPILER/*Opt
./Allwmake
cd ..

# Make run directory
mkdir -p $FOAM_RUN
