#!/bin/bash
#===================================================================================================
# Download photos from the Galaxy S4 (Samsung phone).
#===================================================================================================

echo ""
echo " Downloading photos and videos from the S4"
echo ""

if [ -d /media/s4/DCIM/Camera ]
then
  orderPhotos.py --debug --album=/export/photos/cpAlbum --path=/media/s4/DCIM \
                 --model=T-Mobile-Ana
  echo ""
  echo " Downloading from the S4 is complete."
  echo ""
else
  sudo umount /media/s4
  sudo mkdir  /media/s4
  echo " S4 seems not to be attached, or mounted. Please mount and try again."
  echo " --> sudo simple-mtpfs  -o allow_other /media/s4"
  exit 1
fi

echo " Sync photos."
echo ""
syncPhotos.pl

exit 0
