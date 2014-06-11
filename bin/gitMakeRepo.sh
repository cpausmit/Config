#!/bin/bash

project=`basename $PWD`

echo " Define a new github repository named: $project"
read -p "  -- do you wish to continue? [N/y] " yn
if [ "$yn" != "y" ] && [ "$yn" != "Y" ] 
then
  echo " Nothing done. EXIT."
  exit
else
  clean.csh backup-local
  git init
  git add .
  git commit -m 'First commit.'
  git remote add origin git@github.com:cpausmit/${project}.git
  git remote -v
  git push origin master
fi
