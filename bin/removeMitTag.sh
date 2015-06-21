#!/bin/bash
#---------------------------------------------------------------------------------------------------
# Remove a given tag from all relevant repositories for bambu file production and bambu file
# analysis.
#
# Author: C.Paus                                                                      (Apr 30, 2015)
#---------------------------------------------------------------------------------------------------

function removeTagFromPackage {
  # funtion to install one given package

  package="$1"
  tag="$2"

  echo ""
  echo " ============"
  echo " Removing $tag from $package"
  echo " ============"
  echo ""

  cd $CMSSW_BASE/src/$package
  git tag -d $tag
  git remote set-url origin git@github.com:cpausmit/$package
  git push origin :$tag
}

# determine start time
startTime=`date +%s`

if [ "$1" != "" ]
then
  MIT_TAG=$1
fi

# Check we have everything to proceed
if [ -z $CMSSW_BASE ] || [ -z $MIT_TAG ]
then
  echo ""
  echo " Environment?  CMSSW_BASE ($CMSSW_BASE) and MIT_TAG ($MIT_TAG)"
  echo ""
  exit 1;
fi

echo ""
echo "Removing MIT_TAG: $MIT_TAG (CMSSW: $CMS_VERS)"
echo ""
sleep 4

# Checkout
removeTagFromPackage MitCommon  $MIT_TAG 
removeTagFromPackage MitEdm     $MIT_TAG 
removeTagFromPackage MitProd    $MIT_TAG 
removeTagFromPackage MitAna     $MIT_TAG 
removeTagFromPackage MitPhysics $MIT_TAG 
removeTagFromPackage MitPlots   $MIT_TAG 

endTime=`date +%s`
duration=$(( $endTime - $startTime))

echo " ===="
echo " ==== Tag removal took $duration seconds ====" 
echo " ===="
