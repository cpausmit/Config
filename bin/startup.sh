#!/bin/bash

# setup the x-environment
xrdb -merge /home/$USER/.Xdefaults

# make sure the export area is mounted
/home/$USER/bin/mountExport.sh

exit 0
