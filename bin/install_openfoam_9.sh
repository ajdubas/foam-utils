#!/bin/bash

# Make OpenFOAM directory
mkdir -p $HOME/OpenFOAM
cd $HOME/OpenFOAM

# Get source files
wget -O - http://dl.openfoam.org/source/9 | tar -xvz
mv OpenFOAM-9-version-9 OpenFOAM-9
wget -O - http://dl.openfoam.org/third-party/9 | tar -xvz
mv ThirdParty-9-version-9 ThirdParty-9

# Set environment variables
source $HOME/OpenFOAM/OpenFOAM-9/etc/bashrc

# Build ThirdParty software
cd ThirdParty-9
./Allwmake
cd ..

# Build OpenFOAM
cd OpenFOAM-9
sed -i 's/-O3/-O3 -march=native -mtune=native/g' wmake/rules/$WM_ARCH$WM_COMPILER/*Opt
./Allwmake
cd ..

# Make run directory
mkdir -p $FOAM_RUN
