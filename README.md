# AWACS

RELEASE 0.1

## Introduction

AWACS is a "go-kit" for Signal Intelligence (SIGINT) enthusiasts. It is coded for  

- amd64 platforms with 8GB RAM and 128GB storage minimum runniing **Ubuntu 24.04 LTS**

## Quick Setup

```
git clone https://github.com/joecupano/AWACS.git
cd AWACS
./build_awacs.sh
```

After setup reboot system.

## Hardware Recommendations

### Hardware Config
Since this is a SIGINT platform we do not want to be generating any RF so onboard Bluetooth and WiFi should be disabled. If Internet is needed and only available via WiFi then so be it and use your onboard WiFi.

### USB Peripherals
USB peripherals can be hungry so use a powered USB hub. 

