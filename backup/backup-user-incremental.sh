#!/bin/bash

# The removal of "old" files is done assuming that we only want to
# keep a single incremental backup per user per day. Any previous
# timestamp dated today must be removed before setting BU_LASTTIME in
# order that we use the timestamp of the previous day's backup.

source XX-BU_BASE-XX/bin/setup.sh

export BU_USER=$1
export BU_DIR=$BU_BASE/incremental/$BU_USER
export BU_LOGDIR=$BU_BASE/log/$BU_USER
export BU_LOGSUF=inc
export BU_TIMEDIR=$BU_BASE/timestamp/$BU_USER
export BU_TIMESUF=incremental

export SUBDIRSCRIPT=$BU_BASE/bin/check-user-subdirectory.sh
$SUBDIRSCRIPT $BU_DIR        $BU_TARGET/$BU_USER
$SUBDIRSCRIPT $BU_LOGDIR     $BU_TARGET/$BU_USER
$SUBDIRSCRIPT $BU_TIMEDIR    $BU_TARGET/$BU_USER

export BU_FILE=$BU_DIR/$BU_USER`date +%m%d%y`.$BU_SUFFIX
export BU_LOGFILE=$BU_LOGDIR/$BU_USER`date +%m%d%y`-$BU_LOGSUF
export BU_TIMEFILE=$BU_TIMEDIR/$BU_USER`date +%m%d%y`.$BU_TIMESUF

export BU_TMPFILE=$BU_LOGDIR/increment.files
rm -f $BU_TIMEFILE

# Find out the latest backup of either type.
export BU_LASTTIME=`ls -r1t ${BU_TIMEDIR}/${BU_USER}* | tail -1`

echo ""
echo "--- Incremental backup BEGIN [`date`] --------------------"
echo ""

echo "Found last timestamp: [$BU_LASTTIME]"
echo "Finding modified files ... "

rm -f $BU_TMPFILE

/usr/bin/find $BU_TARGET/$BU_USER -mindepth 1 -cnewer $BU_LASTTIME -and -not -type d > $BU_TMPFILE
echo "Found `wc -l < $BU_TMPFILE` modified files. "
echo ""
# find directories to exclude
echo "Remove files not to be backed up."
OPT=""
if [ -f "$BU_TARGET/$BU_USER/.no-backup" ]
then
  while read -r line
  do
    cat $BU_TMPFILE | grep -v ^"$line" > /tmp/$$.tmp
    mv /tmp/$$.tmp $BU_TMPFILE
  done < "$BU_TARGET/$BU_USER/.no-backup"
fi
echo "Found `wc -l < $BU_TMPFILE` remaining modified files. "

echo "Backup File            [${BU_FILE}]"
echo "Compressed Logfile     [${BU_LOGFILE}.${BU_ZIPSUF}]"
echo "Timestamp              [${BU_TIMEFILE}]"
echo ""

echo "Removing old files... "
rm -f $BU_LOGFILE $BU_LOGFILE.$BU_ZIPSUF $BU_FILE

echo "Creating timestamp ... "
touch $BU_TIMEFILE

echo "Executing backup command ... "
$BU_TARCMD $BU_FILE -T $BU_TMPFILE > $BU_LOGFILE
echo "Compressing backup log file..."
$BU_LOGZIP $BU_LOGFILE

echo ""
echo "--- Incremental backup END [`date`] --------------------"
echo ""
