#!/bin/bash
#===================================================================================================
# Download photos from the Galaxy S7 (Samsung phone).
#
# - first make sure in the pull down to allow access to the device
# - then this script should work
#===================================================================================================

echo ""
echo " Downloading photos and videos from the S7"
echo ""

if [ -d /media/s7/DCIM/Camera ]
then
  orderPhotos.py --debug --album=/export/photos/cpAlbum --path=/media/s7/DCIM \
                 --model=T-Mobile-CP
  echo ""
  echo " Downloading from the S7 is complete."
  echo ""
else
  sudo umount /media/s7
  sudo mkdir  /media/s7
  echo " S7 seems not to be attached, or mounted. Please mount and try again."
  echo " --> sudo simple-mtpfs  -o allow_other /media/s7"
  exit 1
fi

echo " Sync photos."
echo ""
syncPhotos.pl

exit 0
