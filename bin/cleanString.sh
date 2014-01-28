#!/bin/bash
#---------------------------------------------------------------------------------------------------
# Define standard cleanups of a string.
#
#   - cleanContractBasename: removes special characters (including blanks), makes all characters
#                            lowercase and strips the extension (example .mg4)
#
#---------------------------------------------------------------------------------------------------
option="$1"
input="$2"

if [ ".$option" == ".cleanContractBasename" ]
then
  echo "${input%.*}" | sed 's/[\. -!@#\$%^&*()]//g' | tr [A-Z] [a-z]
else
  echo $input
fi

exit 0
