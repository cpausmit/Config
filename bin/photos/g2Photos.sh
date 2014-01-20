#!/bin/bash
#===================================================================================================
# Download photos from the G2 (HTC phone).
#===================================================================================================

echo ""
echo " Downloading photos and videos from the G2"
echo ""

if [ -d /media/3737-3262/DCIM/Camera ]
then
  orderPhotos.py --debug --album=/export/photos/cpAlbum --path=/media/3737-3262/DCIM/Camera \
                 --model=T-Mobile-G2
  echo ""
  echo " Downloading from the G2 is complete."
  echo ""
else
  echo " G2 seems not to be attached, or mounted. Please mount and try again."
  exit 1
fi

echo " Sync photos."
echo ""
syncPhotos.pl

exit 0
