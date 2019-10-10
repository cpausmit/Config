#!/bin/bash
#---------------------------------------------------------------------------------------------------
# Simple installer for the backup environment
#
# For my 'laptop'-desktop I installed with:
#
#    sudo ./install.sh  /backup/paus/bu  /home
#                                                                                  Ch.Paus, Jan 2010
#---------------------------------------------------------------------------------------------------
H=`basename $0`
BU_BASE="$1"
BU_TARGET="$2"

# Read command line arguments
if [ ".$1" == "." ]
then
  echo " usage: ./$H  <backup-dir>  <backup-target>"
  exit 1
fi
if [ ".$2" == "." ]
then
  echo " usage: ./$H  <backup-dir>  <backup-target>"
  exit 1
fi
# Test we are root, otherwise it makes no sense to start
if [ `id -u` != 0 ]
then
  echo " to successfully execute this script you need to me root. exit now!"
  exit 2
fi

# Make sure we are in the right spot
if ! [ -f "backup-user-complete.sh" ]
then
  echo " please execute from directory where install.sh script is located"
  exit 3
fi

# create all necessary directories
echo " create all necessary directories"
mkdir -p $BU_BASE/{bin,complete,html,incremental,log,Public,timestamp}

# copy the scripts
echo " copy script framework"
cp * $BU_BASE/bin/

# configure scripts
echo " configure script framework"
cd $BU_BASE/bin
./repstr "/backup" "$BU_BASE"   *.sh *.awk *crontab
./repstr "/home"   "$BU_TARGET" *.sh *.awk *crontab
chmod a+x *.sh

# install crontab
echo " install configured crontab"
crontab -l             >  new-crontab
cat mit-backup-crontab >> new-crontab
crontab new-crontab

exit 0
