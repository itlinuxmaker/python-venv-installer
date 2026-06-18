# python-venv-installer
A lightweight Python venv installer for developers. Quickly creates and activates virtual environments with a requested Python version. Automatically installs the required Python interpreter and pip when missing, allowing fast setup without manual installation steps.

## Requirements
This project is developed for Debian-based Linux systems.

Before running the installer, the following packages should be installed:

sudo apt update 

sudo apt install -y \
    build-essential \
    wget \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libffi-dev \
    liblzma-dev \
    tk-dev

These packages are required to compile Python from source using make.
For other operating systems, install the equivalent development packages using the native package manager:

* RPM-based Linux distributions (e.g. Fedora, RHEL, CentOS, openSUSE): use dnf, yum or zypper
* macOS: use brew (Homebrew)

The required packages may have different names depending on the operating system.
