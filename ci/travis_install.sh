#!/bin/bash
# This file is based on the following resources:
# https://github.com/rmcgibbo/python-appveyor-conda-example
# https://github.com/rmcgibbo/python-appveyor-conda-example/blob/master/continuous-integration/travis/install.sh
# https://github.com/pandas-dev/pandas/blob/master/ci/install_travis.sh
# https://github.com/pandas-dev/pandas/blob/master/.travis.yml


echo
echo "[install_travis]"

home_dir=$(pwd)
echo
echo "[home_dir]: $home_dir"

# install miniconda
MINICONDA_DIR="$HOME/miniconda3"

echo
echo "[Using clean Miniconda install]"

if [ -d "$MINICONDA_DIR" ]; then
    rm -rf "$MINICONDA_DIR"
fi

# install miniconda
if [ "${TRAVIS_OS_NAME}" == "osx" ]; then
    time wget http://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh || exit 1
else
    time wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh || exit 1
fi
time bash miniconda.sh -b -p "$MINICONDA_DIR" || exit 1

echo
echo "[show conda]"
which conda

echo
echo "[update conda]"
conda config --set ssl_verify false || exit 1
conda config --set always_yes true --set changeps1 false || exit 1
conda update -q conda

if [ "$CONDA_FORGE" ]; then
    # add conda-forge channel as priority
    conda config --add channels conda-forge || exit 1
fi

# Useful for debugging any issues with conda
conda info -a || exit 1

# set the compiler cache to work
echo
if [ -z "$NOCACHE" ] && [ "${TRAVIS_OS_NAME}" == "linux" ]; then
    echo "[Using ccache]"
    export PATH=/usr/lib/ccache:/usr/lib64/ccache:$PATH
    gcc=$(which gcc)
    echo "[gcc]: $gcc"
    ccache=$(which ccache)
    echo "[ccache]: $ccache"
    export CC='ccache gcc'
elif [ -z "$NOCACHE" ] && [ "${TRAVIS_OS_NAME}" == "osx" ]; then
    echo "[Install ccache]"
    brew install ccache > /dev/null 2>&1
    echo "[Using ccache]"
    export PATH=/usr/local/opt/ccache/libexec:$PATH
    gcc=$(which gcc)
    echo "[gcc]: $gcc"
    ccache=$(which ccache)
    echo "[ccache]: $ccache"
else
    echo "[Not using ccache]"
fi

echo
echo "[create env]"

# create our environment
PYTHON_VERSION=$PYVERSION
echo "set up a conda environment with the right Python version: $PYTHON_VERSION"
time conda create -n dbcollection python=$PYTHON_VERSION || exit 1

source activate dbcollection


echo
echo "[show dbcollection]"
conda list -n dbcollection

echo
echo "[done]"
exit 0
