#!/bin/bash
#---------------------------------------------------------------------------------------------------
# Install the bambu software of a given MIT tag into the standard area. The MIT_VERS and CMSSW_BASE
# variables have to be already defined. Best is to also have MIT_TAG defined too but you can specify
# it as the first parameter in the command line.
#
# Author: C.Paus                                                                      (June 4, 2010)
#---------------------------------------------------------------------------------------------------
function installPackage
{
  # funtion to install one given package

  package="$1"
  tag="$2"

  echo ""
  echo " ============"
  echo " Checking Out -- $package"
  echo " ============"
  echo ""

  if [ "0" == "1" ]
  then
    cvs co -d ${package}  -r $tag UserCode/${package}
  else
    git clone https://github.com/cpausmit/$package
    cd $package
    if [ "$MIT_TAG" != "master" ]
    then
      if [ "`git tag -l $MIT_TAG`" == "" ]
      then
        echo " NEW TAG -- git tag -a $MIT_TAG -m \"Production version: $MIT_TAG\""
        git tag -a $MIT_TAG -m "Production version: $MIT_TAG"
        git remote set-url origin git@github.com:cpausmit/$package
        git push origin $MIT_TAG
      else
        echo " Dealing with an existing tag ($MIT_TAG)."
      fi
      git checkout -b "Branch_$MIT_TAG" $tag
    fi

    # post checkout stuff
    if [ -x "./bin/setup.sh" ]
    then
      ./bin/setup.sh
      if [ $? -ne 0 ]
      then
        "$package setup script FAILED. ABORTING NOW!"
        exit 1
      fi
    fi

    # back to where we started
    cd ..
  fi

  if [ -d "./$package" ]
  then
    echo " Checkout of $package worked."
  else
    echo " Checkout of $package FAILED. ABORTING NOW!"
    echo ""
    exit 1
  fi
}

# determine start time
startTime=`date +%s`

if [ "$1" != "" ]
then
  MIT_TAG=$1
fi

# Check we have everything to proceed
if [ -z $MIT_VERS ] || [ -z $CMSSW_BASE ] || [ -z $MIT_TAG ]
then
  echo ""
  echo " Environment?: MIT_VERS ($MIT_VERS) and CMSSW_BASE ($CMSSW_BASE) and MIT_TAG ($MIT_TAG)"
  echo ""
  exit 1;
fi

echo ""
echo "Installing MIT_TAG: $MIT_TAG (CMSSW: $CMS_VERS, MIT production: $MIT_VERS)"
echo ""
sleep 4

# go to our release directory
cd $CMSSW_BASE/src

# Checkout
installPackage MitCommon  $MIT_TAG 
installPackage MitEdm     $MIT_TAG 
installPackage MitProd    $MIT_TAG 
installPackage MitAna     $MIT_TAG 
installPackage MitPhysics $MIT_TAG 
installPackage MitPlots   $MIT_TAG 

# Compile it all
cd $CMSSW_BASE/src
scram build -j 16

endTime=`date +%s`
duration=$(( $endTime - $startTime))

echo " ===="
echo " ==== Installation took $duration seconds ====" 
echo " ===="
