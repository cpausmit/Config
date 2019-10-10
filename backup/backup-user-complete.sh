#!/bin/bash

export BU_BASE="/backup"
export BU_TARGET="/home"

export BU_USER=$1
export BU_TARCMD="tar cvzPf "
export BU_PREFIX=backup
export BU_SUFFIX=tgz
export BU_DIR=$BU_BASE/complete/$BU_USER
export BU_LOGZIP=gzip
export BU_LOGSUF=log
export BU_ZIPSUF=gz
export BU_LOGDIR=$BU_BASE/log/$BU_USER
export BU_TIMEDIR=$BU_BASE/timestamp/$BU_USER
export BU_TIMESUF=complete

export BU_FILE=$BU_DIR/$BU_USER`date +%m%d%y`.$BU_SUFFIX
export BU_LOGFILE=$BU_LOGDIR/$BU_USER`date +%m%d%y`-$BU_LOGSUF
export BU_TIMEFILE=$BU_TIMEDIR/$BU_USER`date +%m%d%y`.$BU_TIMESUF

echo ""
echo "--- Complete backup BEGIN [`date`] --------------------"
echo ""

echo "Backup File            [${BU_FILE}]"
echo "Compressed Logfile     [${BU_LOGFILE}.${BU_LOGZIP}]"
echo "Timestamp              [${BU_TIMEFILE}]"
echo ""

echo "Removing old files... "
rm -f $BU_TIMEFILE
rm -f $BU_LOGFILE $BU_LOGFILE.$BU_ZIPSUF
rm -f $BU_FILE

echo "Creating timestamp ... "
touch $BU_TIMEFILE

# find directories to exclude
OPT=()
if [ -f "$BU_TARGET/$BU_USER/.no-backup" ]
then
  while read -r line
  do
    OPT+=(--exclude=\"$line\")
  done < "$BU_TARGET/$BU_USER/.no-backup"
fi

echo "Executing backup command ... "
EXEC="date; $BU_TARCMD $BU_FILE ${OPT[*]} $BU_TARGET/$BU_USER"
echo "$EXEC > $BU_LOGFILE"
eval  $EXEC > $BU_LOGFILE    # eval splits up the string properly into the pieces
echo "Compressing backup log file..."
echo "$BU_LOGZIP $BU_LOGFILE"
$BU_LOGZIP $BU_LOGFILE

echo ""
echo "--- Complete backup END   [`date`] --------------------"
echo ""
