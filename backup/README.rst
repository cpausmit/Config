backup
======

Introduction
------------

The installation of a backup system on a computer is essential to guarantee your data is secure. This package provides a simple minded and easy to install package to do exactly this.

In essence the package runs under the root account and starts from a given target directory (/home) and produces a tar ball of each given subdirectories (/home/paus). Typically a full backup is performed every week, while incremental backups will be performed on a daily basis adding only files that have been changed since the complete backup. Typically tar balls for two full backups will be kept and the rest will be automatically erased. All those typical numbers can be tuned to the specific case.

Installation
------------

For the installation it is useful to think about how redundant you want to make your backup. You can make a backup on a single computer on a single disk drive. This does not sound very safe, because if the disk fails the backup will not work either. You might consider making the backup on a second disk connected to the same computer (internal or external) or even better on a disk on a separate computer in a different room. The backup system assumes that the disk keeping the tar balls of the backup are mounted on the computer where the backup is being performed. We use an NFS mounted disk.

The installation requires exactly two parameters, which are absolute directory paths. First, the location of the area where the backup data is supposed to be kept (/backup) and second, the trunc of the directory to backup (/home).

Quick Test
..........

Full Installation
.................


Configurations
--------------

Changing Frequency
..................

Excluding Directories
.....................

