#!/bin/bash
#===================================================================================================
# Download photos from the my dropbox account (that mirrors my phone Galaxy S4).
#===================================================================================================

echo ""
echo " Downloading photos and videos from dropbox"
echo ""

if [ -d "/home/$USER/Dropbox/Camera Uploads" ]
then
  orderPhotos.py --album=/export/photos/cpAlbum --path="/home/$USER/Dropbox/Camera Uploads" \
                 --model=T-Mobile-S4 --debug
  echo ""
  echo " Downloading from the Dropbox is complete."
  echo ""
else
  echo " Could not find dropbox directory. Please check: /home/$USER/Dropbox/Camera Uploads."
  exit 1
fi

echo " Sync photos."
echo ""
syncPhotos.pl

exit 0
