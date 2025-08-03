#!/bin/bash

### AWACS Platform Build Script
###
### Installs software and drivers for RF monitoring platform
### Hardware: Green G1 Celeron J4125, RTL-SDR, HackRF, Ubertooth, ESP32 devices

#
# INIT VARIABLES
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
AWACS_BANNER_RESET="\e[0m"

# AWACS Directory tree
AWACS_ROOT=$HOME/AWACS
AWACS_SOURCE=$AWACS_ROOT/src
AWACS_HOME=$AWACS_ROOT/home
AWACS_ETC=$AWACS_ROOT/etc
AWACS_DEVICES=$AWACS_ROOT/devices
AWACS_PACKAGES=$AWACS_ROOT/packages
AWACS_TEMPLATES=$AWACS_ROOT/templates
AWACS_DEBS=$AWACS_ROOT/debs

# AWACS Install Support files
AWACS_INSTALLED_DEVICE=$AWACS_DEVICES/DEVICES

# Detect architecture (x86, x86_64, aarch64, ARMv8, ARMv7)
AWACS_HWARCH=`lscpu|grep Architecture|awk '{print $2}'`
## Detect Operating system (Debian GNU/Linux 11 (bullseye) or Ubuntu 22.04.3 LTS)
AWACS_OSNAME=`cat /etc/os-release|grep "PRETTY_NAME"|awk -F'"' '{print $2}'`
## Is Platform good for install- true or false - we start with false
AWACS_CERTIFIED="false"

#
# FUNCTIONS
#

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

#
# MAIN
#

##
## System Checks
##

# Exit on any error
set -e

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root. Run as regular user with sudo privileges."
   exit 1
fi

# Check if we're in the correct directory
if [ ! -f "build_awacs.sh" ] || [ ! -d "devices" ] || [ ! -d "packages" ]; then
   error "This script must be run from the AWACS source directory containing devices/ and packages/ folders."
   exit 1
fi

# Are we the right hardware and OS
if [ "$AWACS_HWARCH" != "x86_64" ]; then
    echo -e "${RED}ERROR:"
    echo -e "${RED}ERROR:  Incorrect Hardware"
    echo -e "${RED}ERROR:"
    echo -e "${RED}ERROR:  Hardware must be x86_64 - Aborting"
    echo -e "${RED}ERROR:"
    exit 1;
elif [[ "$AWACS_OSNAME" != *"Ubuntu 24.04"* ]]; then
    echo -e "${RED}ERROR:"
    echo -e "${RED}ERROR:  Incorrect Operating System Release"
    echo -e "${RED}ERROR:"
    echo -e "${RED}ERROR:  Operating system must be Ubuntu 24.04 - Aborting"
    echo -e "${RED}ERROR:"
    exit 1;
else
    AWACS_CERTIFIED="true"
fi

##
## System Update
##

sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential git cmake pkg-config protobuf-compiler libprotobuf-c-dev \
    libusb-1.0-0-dev python3-dev python3-setuptools python3-protobuf python3-requests \
    python3-numpy python3-serial python3-usb python3-websockets libpcap-dev \
    libnl-3-dev libnl-genl-3-dev libcap-dev libpcre2-dev libncurses5-dev libsqlite3-dev \
    libssl-dev zlib1g-dev libnm-dev libdw-dev libelf-dev

# libsensors4-dev  - No installation candidate


##
## AWACS Platform Setup
##

log "Starting AWACS Platform Setup..."

# Setup directories
cd ~ 
mkdir -p $AWACS_ROOT && mkdir -p $AWACS_ETC && mkdir -p $AWACS_HOME
mkdir -p $AWACS_TEMPLATES && mkdir -p $AWACS_SOURCE && mkdir -p $AWACS_DEVICES
mkdir -p $AWACS_DEBS 

# Add user to plugdev group for USB access
sudo usermod -a -G plugdev $USER

#
# INSTALL DEVICES
#

# Install bladeRF
if grep -q "bladerf,yes" "$AWACS_INSTALLED_DEVICE"; then
    log "Installing bladeRF support..."
    source $AWACS_DEVICES/device_bladerf
fi

# Install Ettus UHD
if grep -q "ettus,yes" "$AWACS_INSTALLED_DEVICE"; then
    log "Installing Ettus UHD support..."
    source $AWACS_DEVICES/device_ettus
fi

# Install GPS
if grep -q "gpsd,yes" "$AWACS_INSTALLED_DEVICE"; then
    log "Installing GPS support..."
    source $AWACS_DEVICES/device_gpsd
fi

# Install HackRF
if grep -q "hackrf,yes" "$AWACS_INSTALLED_DEVICE"; then
    log "Installing HackRF support..."
    source $AWACS_DEVICES/device_hackrf
fi

# Install LimeSDR
if grep -q "limesuite,yes" "$AWACS_INSTALLED_DEVICE"; then
    log "Installing LimeSDR support..."
    source $AWACS_DEVICES/device_limesuite
fi

# Install Pineapple Nano
if grep -q "pineapplenano,yes" "$AWACS_INSTALLED_DEVICE"; then
    log "Installing Pineapple Nano support..."
    source $AWACS_DEVICES/device_pineapple_nano
fi

# Install PlutoSDR
if grep -q "plutosdr,yes" "$AWACS_INSTALLED_DEVICE"; then
    log "Installing PlutoSDR support..."
    source $AWACS_DEVICES/device_plutosdr
fi

# Install RTLSDR
if grep -q "rtlsdr,yes" "$AWACS_INSTALLED_DEVICE"; then
    log "Installing RTL-SDR support..."
    source $AWACS_DEVICES/device_rtlsdr
fi

# Install SDRPlay
if grep -q "libmirisdr,yes" "$AWACS_INSTALLED_DEVICE"; then
    log "Installing SDRPlay support..."
    source $AWACS_DEVICES/device_libmirisdr
fi

# Install Ubertooth
if grep -q "ubertooth,yes" "$AWACS_INSTALLED_DEVICE"; then
    log "Installing Ubertooth support..."
    source $AWACS_DEVICES/device_ubertooth
fi

# Install ESP32
#if grep esp32,yes "$AWACS_INSTALLED_DEVICE"; then
#    log "Installing ESP32 support..."
#    source $AWACS_DEVICES/device_esp32
#fi

#
# PACKAGES
#

log "Installing packages..."

# Install RTLAMR
source $AWACS_PACKAGES/package_rtlamr

# Install Kismet
source $AWACS_PACKAGES/package_kismet


