#!/bin/bash

source XX-BU_BASE-XX/bin/setup.sh

export DATESTAMP=`date +%m%d%y`
export TOTALLOGDIR=$BU_BASE/html/log
export TOTALLOGFILE=incremental-$DATESTAMP.log

# Make sure that required backup directories exist.
$BU_BASE/bin/check-user-subdirectory.sh $BU_BASE/html/log $BU_BASE/html

# Perform backup.
rm -f $TOTALLOGDIR/$TOTALLOGFILE
$BU_BASE/bin/mit-group-incremental.sh > $TOTALLOGDIR/$TOTALLOGFILE


# 1) Print the following info for each *gz file:
#    $BU_BASE/<dir>/<user name>/<file name>/<Modification time in seconds since epoch>/<Mod. time in readable format>
# 2) Sort by username then directory under $BU_BASE then epoch mod. time. Use stable sorting
#    so that "equal" records are never exchanged.
# 3) Run an awk program to generate the HTML file.
find $BU_BASE/{complete,incremental,log} -type f -name "*gz" -printf "%p/%T@/%t\n" \
  | sort -s -t/  -k4,4  -k3,3  -k6,6nr \
  | gawk -F/ -f $BU_BASE/bin/make-html-log.awk \
  > $BU_BASE/Public/index.shtml

