#!/bin/bash
#--------------------------------------------------------------------------------------------------
# Kill all processes which in 'ps auxw' match a given pattern. This is dangerous, but hell,
# life is an adventure.
#                                                                         V1.0 Ch.Paus: 03 Jun 2010
#--------------------------------------------------------------------------------------------------

# get command line arguments
PATTERN=$1
if [ "$PATTERN" == "" ]
then
  echo ""
  echo " usage: killProc.sh  <pattern> "
  echo ""
fi

# make a list of pids
pidList=`ps auxw | grep -v killProc.sh | grep -v grep | grep $1 | tr -s ' ' | cut -d ' ' -f 2`

# loop through the list and kill'em
for pid in $pidList
do
  echo "  -> killing pid: $pid"
  kill $pid
done
