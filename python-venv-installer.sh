#!/bin/bash
#
# Python Installer and Virtual Environment Manager
# Installs missing Python versions under /opt/python and creates/activates matching venvs.
# Usage: source PythonInstaller.sh <3.x.y>
#
# Author: Andreas Günther, IT-LINUXMAKER
# Version: 1.0.0
# License: MIT
#

REPO="https://www.python.org/ftp/python"

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    echo "This script must be called using 'source':"
    echo "Usage: source ${BASH_SOURCE[0]} <3.x.y>"
    return
fi

if ! [[ "$1" =~ ^3\.[0-9]+\.[0-9]+$ ]]; then
	echo "Usage: source ${BASH_SOURCE[0]} <3.x.y>"
	echo "Invalid Python 3 version!"
	return
fi

VERSION=$1
USER=$(whoami)
STARTDIR=$PWD
OPT="/opt/python"
DIR=$HOME/Python_venv
VENVDIR=$DIR/python-$VERSION

if [ -f "$VENVDIR/bin/activate" ]; then
	source "$VENVDIR/bin/activate"
	echo "Python version $(python3 --version) is activated!"
else
	if [ ! -d "$OPT" ]; then
		su -c '
		mkdir -p '$OPT'
		chown '"$USER:$USER"' '$OPT'
		'
	fi

	PYTHON="$OPT/$VERSION/bin/python${VERSION%.*}"
	if [ ! -x "$PYTHON" ]; then
		if ! wget --spider -q "$REPO/$VERSION/Python-$VERSION.tgz"; then
        	echo "Python version $VERSION does not exist in the repository!"
        	return 1
    	fi
		mkdir -p "$OPT/$VERSION"
		cd /tmp
		wget "$REPO/$VERSION/Python-$VERSION.tgz" 
		tar xzf Python-$VERSION.tgz
		cd Python-$VERSION
		./configure --prefix=/opt/python/$VERSION
		make -j$(nproc)
		
		cd "$STARTDIR"
		make -C "/tmp/Python-$VERSION" install

		rm -rf "/tmp/Python-$VERSION"
		rm -f "/tmp/Python-$VERSION.tgz"
	else
		echo "$OPT/$VERSION already exists"
	fi	

	# Installation of pip, if not already present
	if ! "$PYTHON" -m pip --version >/dev/null 2>&1; then
		if ! "$PYTHON" -m ensurepip --upgrade >/dev/null 2>&1; then
			wget -q https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
			"$PYTHON" /tmp/get-pip.py >/dev/null 2>&1
		fi
	fi

	# Terminate program if pip does not exist
	"$PYTHON" -m pip --version >/dev/null 2>&1 || return 1

	# Installation of the virtual Python environment
	mkdir -p "$DIR"
	if [ ! -f "$VENVDIR/bin/activate" ]; then
			"$PYTHON" -m venv "$VENVDIR"
    fi			
	
	source "$VENVDIR/bin/activate"
	python3 -m pip install --upgrade pip setuptools wheel
	echo "Python version $(python3 --version) is activated!"
fi			




