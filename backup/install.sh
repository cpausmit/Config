#!/bin/bash
#---------------------------------------------------------------------------------------------------
# Simple installer for the backup environment
#
# For my 'laptop'-desktop I installed with:
#
#    sudo ./install.sh  /backup  /home
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
  echo " to successfully execute this script you need to be root. exit now!"
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
./repstr "XX-BU_BASE-XX"   "$BU_BASE"   *.sh *.awk *crontab >> install.log
./repstr "XX-BU_TARGET-XX" "$BU_TARGET" *.sh *.awk *crontab >> install.log
chmod a+x *.sh

# install crontab
echo " INFO - existing crontab"
crontab -l
echo ""
echo " INFO - more crontab ?"
cat mit-backup-crontab
echo -n "Do you want to add more crontab for the backup? [y/N]: "
read yes
if [ "$yes" == "y" ] || [ "$yes" == "Y" ]
then
  crontab -l             >  new-crontab
  cat mit-backup-crontab >> new-crontab
  crontab new-crontab
else
  echo " INFO - crontab is unchanged, see below"
  crontab -l
fi

exit 0
