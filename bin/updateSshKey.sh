#!/bin/bash
usage=' usage:  updateSshKey.sh  <hostname>  [ <user> ]'
MACHINE="$1"
REMOTE_USER="$2"
if [ -z "$MACHINE" ]
then
  echo $usage
  exit 1
fi
if [ -z "$REMOTE_USER" ]
then
  REMOTE_USER=$USER
fi

myKey=`cat $HOME/.ssh/id_rsa.pub`
echo $myKey
echo " Updating ssh keys on $MACHINE for user $REMOTE_USER"

ssh $REMOTE_USER@$MACHINE \
   "mkdir -p .ssh; touch .ssh/authorized_keys; chmod 600 .ssh/authorized_keys; \
    ls -l .ssh/authorized_keys; echo $myKey >> .ssh/authorized_keys"
