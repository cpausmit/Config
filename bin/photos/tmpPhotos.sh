#!/bin/bash
#===================================================================================================
# Download photos from some temporary directory.
#===================================================================================================
TMPDIR="/export/photos/tmp"

echo ""
echo " Downloading photos and videos from dropbox"
echo ""

if [ -d "$TMPDIR" ]
then
  orderPhotos.py --album="/export/photos/cpAlbum" --path=$TMPDIR \
                 --model=T-Mobile-S7 --debug
  echo ""
  echo " Downloading from the tmp is complete."
  echo ""
else
  echo " Could not find tmp directory. Please check: $TMPDIR Uploads."
  exit 1
fi

echo " Sync photos."
echo ""
syncPhotos.pl

exit 0
