#!/bin/bash
DATE=`date +%y%m%d`
source $HOME/Work/Krone/setup.sh
cmd="c19.py --quiet --update --combine=7 --relative --delta --tmin=2022-01-01"
echo "$cmd"
$cmd
mv c19.png ~/Pictures/c19-relative-US-MA-CH-FR-${DATE}.png

echo "Find plot at: ~/Pictures/c19-relative-US-MA-CH-FR-${DATE}.png"
