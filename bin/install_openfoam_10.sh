#!/bin/bash

# Make OpenFOAM directory
mkdir -p $HOME/OpenFOAM
cd $HOME/OpenFOAM

# Get source files
wget -O - http://dl.openfoam.org/source/10 | tar -xvz
mv OpenFOAM-10-version-10 OpenFOAM-10
wget -O - http://dl.openfoam.org/third-party/10 | tar -xvz
mv ThirdParty-10-version-10 ThirdParty-10

# Set environment variables
source $HOME/OpenFOAM/OpenFOAM-10/etc/bashrc

# Build ThirdParty software
cd ThirdParty-10
./Allwmake
cd ..

# Build OpenFOAM
cd OpenFOAM-10
sed -i 's/-O3/-O3 -march=native -mtune=native/g' wmake/rules/$WM_ARCH$WM_COMPILER/*Opt
./Allwmake
cd ..

# Make run directory
mkdir -p $FOAM_RUN
