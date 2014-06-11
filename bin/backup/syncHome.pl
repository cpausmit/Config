#!/usr/bin/perl
use strict;
my $home        = "/home/paus";
my $machine     = "ana\@dragocolosus.dyndns.org";
my $folder      = "paus";
my $LOCAL_BASE  = "/home";
my $REMOTE_BASE = "/export/backup/paushaus";
################################################################################
sub show_documentation {
  print STDOUT "

  ACTION
  ======

    Small script to synchronize the home directories between

        folder: $folder

        master: $LOCAL_BASE
        slave:  $machine:$REMOTE_BASE
        

  SYNTAX
  ======

    syncHome.pl
  \n\n";
}
# Called from user only
# VERSION 1.0                                                (02/16/2012) C.Paus
################################################################################
my @dirs;
my $rc;
my $dir;
my $cmd;
my $trunc;
my @f;

if    ($ARGV[0] eq "-h") {
  &show_documentation;
  die;
}

# Create log directory
$cmd = "mkdir -p /tmp/backup-log-$folder";
system($cmd);

$cmd = "";
if (-e "/tmp/backup-log-$folder/$folder.log") {
  $cmd .= "mv /tmp/backup-log-$folder/$folder.log /tmp/backup-log-$folder/$folder.log.bak; ";
}
$cmd  .= "rsync -Cavz ";
$cmd  .= " $LOCAL_BASE/$folder $machine:$REMOTE_BASE";
$cmd  .= " > /tmp/backup-log-$folder/$folder.log";

$rc    = system("$cmd");

exit 0;
