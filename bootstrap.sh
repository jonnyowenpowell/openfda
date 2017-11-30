#!/bin/bash

#
# Python
#
rm -rf build/ .eggs/ _python-env openfda.egg-info/

export LANG=C

# We emulate readlink with python, so we can work on OSX without greadlink.
# From: http://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-
# of-gnus-readlink-f-on-a-mac
PYTHON_ENV=$(python -c 'import os,sys;print os.path.realpath(sys.argv[1])' ./_python-env)

PYTHON=$(which python)
# Setup virtualenv if it doesn't exist.
test -e $PYTHON_ENV || virtualenv -p $PYTHON $PYTHON_ENV
test -e $PYTHON_ENV || ( echo 'You need virtualenv!' && exit 1)

# Install project sources and dependencies into the environment
$PYTHON_ENV/bin/pip install awscli
$PYTHON_ENV/bin/pip install -U -r  requirements.txt
$PYTHON_ENV/bin/python setup.py develop


#
# Node
#
pushd api/faers
echo 'installing node modules for API'
npm install
popd
pushd openfda/spl
echo 'installing node modules for build'
npm install
popd
