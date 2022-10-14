#!/bin/bash
DATE=`date +%y%m%d`
source ~/Work/Krone/setup.sh
c19.py --update --combine=7 --relative --delta --tmin=2022-01-01
mv c19.png ~/Pictures/c19-relative-US-MA-CH-FR-${DATE}.png

echo "Find plot at: ~/Pictures/c19-relative-US-MA-CH-FR-${DATE}.png"
