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

Now locate the suggested crontabs (), review the parameters used and adjust and install them. **Be careful not to overwrite an existing crontab**.
::

  cd Config/backup
  emacs -nw ./new-crontab
  crontab < ./new-crontab

  
Configurations
--------------

Changing Frequency
..................

Excluding Directories
.....................

