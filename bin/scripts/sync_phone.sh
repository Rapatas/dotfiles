#!/bin/bash

set -e

PWD=`pwd`
ARCHIVE="/media/andy/MightyDrive/Inbox/Phone"

if [[ $PWD != *"mtp"* ]]; then
  echo "Please run this script from the phone root."
  exit 1
fi

if [[ ! -d "/media/andy/MightyDrive" ]]; then
  echo "MightyDrive not mounted!"
  exit 1
fi

declare -a paths=(
  "DCIM/Camera"
  "bluetooth"
  "Download"
  "hpscan/documents"
  "Movies/Viber"
  "Pictures"
  "viber/media"
)

INTERNAL="Internal shared storage"

echo "Copying..."
for i in "${paths[@]}"
do
  rsync -a "$PWD/$INTERNAL/$i" "$ARCHIVE/" || true
done

echo "Copying complete! You can unmount the device."

echo "Sorting..."

# Internal
cd "$ARCHIVE/Camera"
exiftool '-FileName<DateTimeOriginal' -d %Y/%m/%Y%m%d_%H%M%%+c.%%e .
exiftool '-DateTimeOriginal<FileModifyDate' .
rm *_original
exiftool '-FileName<DateTimeOriginal' -d %Y/%m/%Y%m%d_%H%M%%+c.%%e .
cp -r * "/media/andy/MightyDrive/Documents/Media/ARCHIVE/1. Internal"
cd ..
rm -rf Camera

# Manual check [OK]
