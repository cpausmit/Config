#!/bin/bash
#---------------------------------------------------------------------------------------------------
usage=' usage:  updateSshKey.sh  <hostname>'

MACHINE="$1"
if [ -z "$MACHINE" ]
then
  echo $usage
  exit 1
fi

myKey=`cat $HOME/.ssh/id_rsa.pub`
echo $myKey
echo " Updating ssh keys on $MACHINE"

ssh $MACHINE "mkdir -p .ssh; touch .ssh/authorized_keys; chmod 600 .ssh/authorized_keys; \
              ls -l .ssh/authorized_keys; echo $myKey >> .ssh/authorized_keys"

exit 0
