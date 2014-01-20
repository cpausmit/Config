#!/usr/bin/perl
use strict;
################################################################################
sub show_documentation {
  print STDOUT "

  ACTION
  ======

    Small script to pack up essential data to be carried over from one account
    to the next.

  SYNTAX
  ======

    pack.pl  config-file [ <exec = no> ]

      config-file -  specifies all directories/files (relative to home) which
                     should be packed up into the tar file.
      exec        -  option to specify whether or not to really execute the
                     request.

  Note: We are going to make one assumption which is that the number of files
    in the configuration is small enough not to be longer then input buffer of
    the shell because we are concatenating them for the tar.  This should not
    be a problem.\n\n";
}
# Called from user only
# VERSION 1.0                                                (29/08/2004) C.Paus
################################################################################
my $CONF = "Desktop/config/private.conf";
my $EXEC = "no";
my $rc;
my $cmd;
my @f;
my $trunc;
my $tarBall;

if    ($#ARGV == 0) {
  $CONF = $ARGV[0];
}
elsif ($#ARGV == 1) {
  $CONF = $ARGV[0];
  $EXEC = $ARGV[1];
}
else {
  &show_documentation;
  die;
}

# Create the target string first
my $targets;
printf "\nParsing config file: $CONF\n";
open(INPUT,"<$CONF");
while (<INPUT>) {
  if (! m/^#/) {
    chop($_);
    $targets .= "$_ ";
    printf "  Adding: $_\n";
  }
}
close(INPUT);

# Generate the tar ball name
@f       = split("/",$CONF);
$trunc   = pop(@f);
@f       = split('\.',$trunc);
$trunc   = shift(@f);
$tarBall = "${trunc}.tgz";

# Create the tar ball now
$rc  = 0;
$cmd = "tar fzc /tmp/$tarBall $targets";
printf "\nTarrrring it up:\n  $cmd\n";
if ("$EXEC" eq "exec") {
  $rc = system("cd; $cmd; chmod 600 /tmp/$tarBall");
}
printf "  done with exit code: $rc\n\n";

exit $rc;
