#!/bin/bash
#===================================================================================================
#
# Script to automatically syncronize our local database with a list of playlists that we are
# maintaining on youtube. This little script is based on a nice script ytplaylistfetcher which
# is free software. The beauty of course is that a video that has alread been downloaded will
# not be downloaded again. So just incremental changes will be applied, avoiding long download
# times.
#
#  Packages to install:  ytplaylistfetcher (somewhere from the web)
#
#                        - sudo yum install -y cclive clive lynx perl-Getopt-Long-Descriptive \
#                                              perl-Web-Scraper  perl-LWP-Protocol-https \
#                                              youtube-dl
#
#                        - mkdir $USER/Tools
#                        - cd    $USER/Tools
#                        - git clone git://git.carbon-project.org/ytplaylistfetcher.git
#
#
#                                                                             Ch.Paus (Nov 06, 2011)
#===================================================================================================
export PATH="${PATH}:${HOME}/Tools/ytplaylistfetcher"

DATABASE=${HOME}/Music
if [ "$1" == "" ]
then
  PLAYLISTS="./PlayLists.txt"
else
  PLAYLISTS="$1"
fi

# Is the List of PlayList really there?

if [ -e "$PLAYLISTS" ]
then
  echo " List of playlists (exists): $PLAYLISTS"
else
  echo " ERROR -- list of playlists does not exist. EXIT!"
  exit 1
fi

# Do we have a database directory?

if [ -d "$DATABASE" ]
then
  echo " Database          (exists): $DATABASE"
else
  echo " ERROR -- database does not exist. EXIT!"
  exit 1
fi

# Start the loop through the play lists

while read line
do

  dir=`   echo $line | tr -s ' ' | cut -d ' ' -f1`
  pLstId=`echo $line | tr -s ' ' | cut -d ' ' -f2`


  # The meat: do the synchronization

  echo ""
  echo " Synchronizing playlist: $dir (id: $pLstId) "
  mkdir -p $DATABASE/$dir
  cd       $DATABASE/$dir
  echo " ytplaylistfetcher -d http://www.youtube.com/playlist?list=$pLstId >& sync.log"
  echo " Execute:  ytplaylistfetcher -d  http://www.youtube.com/playlist?list=$pLstId"  > sync.log
  echo " "                                                                             >> sync.log
  #ytplaylistfetcher -d http://www.youtube.com/playlist?list=$pLstId                    >> sync.log

  
done < $PLAYLISTS

exit 0
