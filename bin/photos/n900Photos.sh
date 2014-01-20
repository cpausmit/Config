#!/bin/bash
#===================================================================================================
# Download photos from the G2 (HTC phone).
#===================================================================================================

echo ""
echo " Downloading photos and videos from the N900"
echo ""

if [ -d "/media/Nokia N900/DCIM" ]
then
  orderPhotos.py --debug --album=/export/photos/cpAlbum --path="/media/Nokia N900/DCIM"
  echo ""
  echo " Downloading from the N900 is complete."
  echo ""
else
  echo " N900 seems not to be attached, or mounted. Please mount and try again."
fi

exit 0
