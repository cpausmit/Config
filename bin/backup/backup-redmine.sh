#!/bin/bash
#----------------------------------------------------------------------------------------------------
# Backup all data related to the redmine installation. Careful, this has to be run as root!
#
#                                                                          C.Paus V 1.0 (Feb 27,2013)
#----------------------------------------------------------------------------------------------------

# Definitions
BACKUP_RMDB=/var/lib/mysql/redmine       # Redmine database location
BACKUP_RMROOT=/home/system/redmine-2.4.3 # Redmine root directory
BACKUP_TARGET=/home/system/backup        # target directory for backup

# Timestamp to keep track of versions
timeStamp=`date +"%Y-%m-%d@%H:%M:%S"`
echo ""
echo " Performing backup for Redmine: $timeStamp"
echo ""

# Make sure target area exists
mkdir -p $BACKUP_TARGET
if [ "$?" != "0" ]
then
  echo " ERROR - target area did not exist and cannot be created."
  exit
fi

# Setup database backup
echo " -> backing up database to: ${BACKUP_TARGET}/redmine_db_${timeStamp}.tgz"
path=`dirname $BACKUP_RMDB`
dir=`basename $BACKUP_RMDB`

# Create tar ball
cd  $path
tar fzc ${BACKUP_TARGET}/redmine_db_${timeStamp}.tgz $dir
if [ "$?" != "0" ]
then
  echo "    ERROR - target area did not exist and cannot be created."
  exit
else
  echo "    INFO - tar command finished successfully."  
  echo ""
fi


# Create tar ball
echo " -> backing up files to: ${BACKUP_TARGET}/redmine_files_${timeStamp}.tgz"
cd $BACKUP_RMROOT
tar fzc ${BACKUP_TARGET}/redmine_files_${timeStamp}.tgz files
if [ "$?" != "0" ]
then
  echo "    ERROR - target area did not exist and cannot be created."
  exit
else
  echo "    INFO - tar command finished successfully."  
  echo ""
fi

exit 0;
