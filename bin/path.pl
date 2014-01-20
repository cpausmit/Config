#!/usr/bin/perl
use strict;
my($n,$home,$date,$h);
################################################################################
#
sub show_documentation {
  my ($exit_code) = shift(@_);
  print STDOUT "

  ACTION
  ======

    Perform several operations on a path type envirnonment variable.

  SYNTAX
  ======

    $n  <operation> <path_name> <list ..>\n\n";
  exit $exit_code;
}
#
# Called from user only
# VERSION 1.0                                                (17/08/2000) C.Paus
################################################################################
my ($COMM,$PATH);
#-------------------------------------------------------------------------------
my ($exit_code);
my ($path,$f);
my (@f,@g);
#-------------------------------------------------------------------------------
$n = `basename $0`; chop($n); $h="$n>";
$home = $ENV{'HOME'} || $ENV{'LOGDIR'} || (getpwuid($<))[7] || die "No Home!\n";
$date = `date +'%y%m'`; chop($date);

if ($ARGV[0] eq "-h"  || $#ARGV < 0 ) {
  &show_documentation($exit_code);
}
#-------------------------------------------------------------------------------

$COMM = $ARGV[0]; shift(@ARGV);
$PATH = $ARGV[0]; shift(@ARGV);

if    ("$COMM" eq "show") {
  printf "$ENV{$PATH}\n";
}
elsif ("$COMM" eq "show-nice") {
  @f = split(":",$ENV{$PATH});
  foreach $f (@f) { printf "$f\n"; }
}
elsif ("$COMM" eq "prepend") {
  $path = join(":",@ARGV);
  $ENV{$PATH} = "$path:$ENV{$PATH}";
  printf "$ENV{$PATH}\n";
}
elsif ("$COMM" eq "append") {
  $path = join(":",@ARGV);
  $ENV{$PATH} = "$ENV{$PATH}:$path";
  printf "$ENV{$PATH}\n";
}
elsif ("$COMM" eq "delete") {
  foreach $path (@ARGV) {
    @f = split(":",$ENV{$PATH});
    @g = ();
    foreach $f (@f) { if ("$f" ne "$path") { push(@g,"$f"); } }
    $ENV{$PATH} = join(":",@g);
  }
  printf "$ENV{$PATH}\n";
}
