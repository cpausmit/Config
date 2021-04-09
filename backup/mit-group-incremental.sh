#!/bin/bash

export BU_BASE="/backup"
export BU_TARGET="/home"

echo "####====---- Starting MIT group incremental [`date`] ----====####"
echo ""

# -mindepth 1: Don't apply the tests to $BU_TARGET itself (depth 0).
# -maxdepth 1: Don't go deeper than what's just below $BU_TARGET (depth 1).
# -type d: We're only interested in directories.
# -not -nouser: Must have owner UIDs defined in the passwd file (or NIS map).
# -not -name lost+found: Useless to back this up.
for LUZER in `find $BU_TARGET -mindepth 1 -maxdepth 1 -type d -and -not -nouser -and -not -name lost+found -printf "%f "`
do
  echo "####====---- Backing up user [$LUZER] ----====#### "
  $BU_BASE/bin/backup-user-incremental.sh $LUZER
done

echo ""
echo "####====---- MIT group incremental complete [`date`] ----====#### "
