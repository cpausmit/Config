#!/bin/bash

DROPBOX_HOME=/export/home/$USER
cd $DROPBOX_HOME
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
if ! [ -e "./.dropbox-dist/dropboxd" ]
then
    wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    echo " Copy the link in the output and open the fireefox on your local computer to connect this installation "
fi
HOME=$DROPBOX_HOME ./.dropbox-dist/dropboxd &
sleep 40

