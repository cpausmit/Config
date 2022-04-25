backup
======

Introduction
------------

The installation of a backup system on a computer is essential to guarantee your data is secure. This package provides a simple and easy to install package to do exactly this.

In essence the package runs under the root account and starts from a given target directory (/home) and produces a tar ball of each given subdirectories (/home/paus). Typically a full backup is performed every week, while incremental backups will be performed on a daily basis adding only files that have been changed since the complete backup. Typically tar balls for two full backups will be kept and the rest will be automatically erased. All those typical numbers can be tuned to the specific case.

Installation
------------

For the installation it is useful to think about how redundant you want to make your backup. You can make a backup on a single computer on a single disk drive. This does not sound very safe, because if the disk fails the backup will not work either. You might consider making the backup on a second disk connected to the same computer (internal or external) or even better on a disk on a separate computer in a different room. The backup system assumes that the disk keeping the tar balls of the backup are mounted on the computer where the backup is being performed. We use an NFS mounted disk.

The installation requires exactly two parameters, which are absolute directory paths. First, the location of the area where the backup data is supposed to be kept (/backup, an NFS mounted disk) and second, the trunc of the directory to backup (/home, the home disk).

The installation has to be performed as user root (or using sudo), and it will copy the software onto the backup location (/backup) and will configure it with the proper directories of your choosing. Then you have to install the crontabs under the root account to specify when the backup program is supposed to run.

Quick Test
..........

To see how this is all working on your system we have a script (test_backup) that, if run as root, generates a test directory and a bunch of subdirectories and files. The area generated will be '/home/test' with a bunch a directories and very small files.


Full Installation
.................

Make sure to identify the backup location (default: /backup) and the target directory (default: /home) you want to backup. Then install your system as root by doing:
::

  cd Config/backup
  ./install.sh /backup /home

The standard installation already installs a default crontab. If you select not to install it because you want to first tune it The following instructions tell you how to do it.

Locate the suggested crontabs, review the parameters used and adjust and install them. **Be careful not to overwrite an existing crontab**.
::

  cd Config/backup
  cp ./new-crontab ./my-crontab
  emacs -nw ./my-crontab
  crontab < ./my-crontab

Now the backup get's executed and all should be done.
   
Configurations
--------------

Changing Frequency
..................

To change the frequency of the backup and fine tune the behaviour you can edit the crontab to your liking. Details of what the entries in the crontab mean can be found for example `here <https://www.adminschoice.com/crontab-quick-reference>`_.

Excluding Users from Backup
...........................

Some users do not or should not be backed up (ex. condor or slurm). In the backup target directory the file .exclude-users can specify users that should be excluded from the backup (ex. /home/.exclude-users).

Excluding Files with Certain Extensions
.......................................

The backup is foreseen to backup files that are difficult to reproduce and usually small. Typically this should not exclude data files. Therefore it is possible to exclude certain extensions from the backup. By default the file excluded-extensions in the home directory specifies the *.root pattern. Other patterns can be added, one per line.

Excluding Directories
.....................

It is sometimes useful for users to be able to exclude certain directories from the backup. A typical example would be your dropbox folder that could be significant but has already a secure copy in a different place. The backup package will read all directories entered into the file '/home/<user>/.no-backup'. Each directory should be written in a separate line. So, an example could look like this:
::
   $ cat /home/user/.no-backup

   /home/user/Dropbox
   /home/user/Videos

   
Display what we have
--------------------

The listing of files in the backup can be easily seen by looking at

   firefox file:///backup/Public/index.shtml

Assuming that your backup location is /backup, otherwise replace accordingly.
