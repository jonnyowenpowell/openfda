#!/bin/bash

#
# Python
#
rm -rf build/

export LANG=C

# We emulate readlink with python, so we can work on OSX without greadlink.
# From: http://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-
# of-gnus-readlink-f-on-a-mac
PYTHON_ENV=$(python -c 'import os,sys;print os.path.realpath(sys.argv[1])' ./_python-env)

PYTHON=$(which python)
if [[ -n MACHTYPE ]]; then
  PIP="pip2 install"
else
  PIP="pip2 install --user"
fi

sudo -H $PIP virtualenv

# Setup virtualenv if it doesn't exist.
test -e $PYTHON_ENV || virtualenv -p $PYTHON $PYTHON_ENV

# Install project sources and dependencies into the environment
$PYTHON_ENV/bin/pip install awscli
$PYTHON_ENV/bin/pip uninstall -y openfda || true
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
