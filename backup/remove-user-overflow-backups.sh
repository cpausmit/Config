#!/bin/bash

export BU_BASE="/backup"
export BU_TARGET="/home"

export BU_USER=$1
export BU_TARGET=$BU_TARGET/$BU_USER
export BU_RMCMD="rm -f"
export BU_COMPDIR=$BU_BASE/complete/$BU_USER
export BU_INCRDIR=$BU_BASE/incremental/$BU_USER
export BU_LOGDIR=$BU_BASE/log/$BU_USER
export BU_TIMEDIR=$BU_BASE/timestamp/$BU_USER

export SUBDIRSCRIPT=$BU_BASE/bin/check-user-subdirectory.sh

$SUBDIRSCRIPT $BU_COMPDIR $BU_TARGET
$SUBDIRSCRIPT $BU_INCRDIR $BU_TARGET
$SUBDIRSCRIPT $BU_LOGDIR  $BU_TARGET
$SUBDIRSCRIPT $BU_TIMEDIR $BU_TARGET

echo ""
echo "--- PRUNING old backups BEGIN [`date`] --------------------"
echo ""

# We want to keep only one prior set of (full backup+incrementals).
export BU_LASTKEEPLONG=`ls -rt1 $BU_TIMEDIR/*.complete | tail -1`
if [ ".$BU_LASTKEEPLONG" != "." ]
then
  export BU_LASTKEEPSHORT=`basename $BU_LASTKEEPLONG`
  export LASTKEEPDATE=`find $BU_TIMEDIR -name $BU_LASTKEEPSHORT -printf %t `

  echo "Last timestamp to keep: $BU_LASTKEEPLONG"

  # The timestamp file is created before any backup tarball so "-not -newer" is correct.
  echo "Files older than [$LASTKEEPDATE] being removed: "

  for DEADFILE in `find $BU_COMPDIR  -mindepth 1 -not -newer $BU_LASTKEEPLONG`
  do
    echo  "-- $DEADFILE "
    $BU_RMCMD $DEADFILE
  done
  
  for DEADFILE in `find $BU_INCRDIR  -mindepth 1 -not -newer $BU_LASTKEEPLONG`
  do
    echo  "-- $DEADFILE  "
    $BU_RMCMD $DEADFILE
  done
  
  for DEADFILE in `find $BU_TIMEDIR -mindepth 1 -not -newer $BU_LASTKEEPLONG | grep -v $BU_LASTKEEPLONG `
  do
    echo  "-- $DEADFILE "
    $BU_RMCMD $DEADFILE
  done
  
  for DEADFILE in `find $BU_LOGDIR  -mindepth 1 -not -newer $BU_LASTKEEPLONG`
  do
    echo  "-- $DEADFILE "
    $BU_RMCMD $DEADFILE
  done

else
  echo "There is no prior complete backup so nothing gets pruned."
fi

echo ""
echo "--- PRUNING old backups END   [`date`] --------------------"
echo ""
