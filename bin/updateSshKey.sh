#!/bin/bash
MACHINE="$1"

myKey=`cat $HOME/.ssh/id_rsa.pub`
echo $myKey
echo " Updating ssh keys on $MACHINE"

ssh $MACHINE "mkdir -p .ssh; touch .ssh/authorized_keys; chmod 600 .ssh/authorized_keys; \
              ls -l .ssh/authorized_keys; echo $myKey >> .ssh/authorized_keys"
