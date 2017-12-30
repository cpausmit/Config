#!/usr/bin/perl
use strict;
my $home = "/export/photos/cpAlbum";
my $machine = "paus\@paushaus.dyndns.org";
my $backup = "/export/backup/data";
################################################################################
sub show_documentation {
  print STDOUT "

  ACTION
  ======

    Small script to synchronize the photo albums between local and backup.

        local:  $home
        backup: $machine:$backup


  SYNTAX
  ======

    synchPhotos.pl

  \n\n";
}
# Called from user only
# VERSION 1.0                                                (29/08/2004) C.Paus
################################################################################
my @dirs;
my $rc;
my $cmd;

if    ($ARGV[0] eq "-h") {
  &show_documentation;
  die;
}

# Create log directory
$cmd = "mkdir -p $home/backup-log";
system($cmd);

printf "#-----";
printf " Start synchronizing $home\n";

if (! (-e "$home/backup-log/current.log")) {
    $cmd = "mv $home/backup-log/current.log $home/backup-log/last.log; ";
}

$cmd  = "rsync -avz -x --rsh=ssh $home $machine:$backup > $home/backup-log/current.log";
printf "RSYNC: $cmd\n";
$rc   = system("$cmd");

$cmd  = "ssh $machine \"source .bash_profile; makeGalleries.pl\" ";
$cmd .=  ">> $home/backup-log/current.log";
printf "UPDATE: $cmd\n";
$rc   = system("$cmd");

exit 0;
