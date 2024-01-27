#!/bin/bash -e
echo "Please enter your computer password if prompted"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
EDL_DIR=$DIR/edl

if [ ! -d  $EDL_DIR ]; then
  git clone https://github.com/bkerler/edl edl
  cd $EDL_DIR
  git submodule update --depth=1 --init --recursive
  python -m pip install -r requirements.txt
  sudo apt purge -y modemmanager
  cd .. 
fi

$EDL_DIR/edl --memory="UFS"
$EDL_DIR/edl w recovery recovery.img
# from OTA
[ -f files/logo.bin ] && $EDL_DIR/edl w LOGO files/logo.bin
$EDL_DIR/edl w boot files/boot.img
$EDL_DIR/edl w system files/system.img

# clear userdata
# TOO SLOW ~60m on device compared to ~0.5s of fastboot prob because it does deepclean
#$EDL_DIR/edl e userdata 
$EDL_DIR/edl e cache
$EDL_DIR/edl reset
