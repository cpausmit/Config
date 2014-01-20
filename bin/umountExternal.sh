#!/bin/bash
#===================================================================================================
# Try to mount the external drive from pausserv.home
#===================================================================================================

# check whether external already mounted
test=`df -h | grep /external`
if [ ".$test" != "." ]
then
  # external mounted (fine)
  echo " it's mounted! Let's unmount it now."
  sudo umount -f /external
  if [ ".$?" == ".0"  ]
  then
    # all good say bye
    echo " unmounting worked."
    echo ""
    read -p "press return!" q
    exit 0
  else
    # umounting failed
    echo " unmounting failed. Stop xbmc program and try again. If all fails just reboot!"
    echo ""
    read -p "press return!" q
    exit 1
  fi
else
  # all good say bye
  echo " unmounting not necessary as /external is not mounted. All good!"
  echo ""
  read -p "press return!" q
  exit 0
fi  

read -p "press return!" q
exit 0
