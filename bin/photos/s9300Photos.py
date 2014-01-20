#!/bin/bash
#===================================================================================================
# Download photos from the G2 (HTC phone).
#===================================================================================================

PhotoPath="/media/6266-3938/DCIM"

echo ""
echo " Downloading photos and videos from the s9300"
echo ""

if [ -d "$PhotoPath" ]
then
  echo ""
  echo "  orderPhotos.py --debug --album=/export/photos/cpAlbum --path=\"$PhotoPath\""
  echo ""
  orderPhotos.py --debug --album=/export/photos/cpAlbum --path="$PhotoPath"
  echo ""
  echo " Downloading from the Nikon S9300 is complete."
  echo ""
else
  echo " Nikon S9300 seems not to be attached, or mounted. Please mount and try again."
  exit 1
fi

echo " Sync photos."
echo ""
syncPhotos.pl

exit 0
