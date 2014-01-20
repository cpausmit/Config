#!/usr/bin/perl
use strict;
my($n,$home,$date,$h);
################################################################################
#
sub show_documentation {
  print STDOUT "

  ACTION
  ======

    Small script to generate html sequences for all the eps pictures
    contained in the given latex file.

  SYNTAX
  ======

    $n  <file>

      <file>  the latex source file to be considered looking for eps inputs

\n\n";
}
#
# Called from user only
# VERSION 1.0                                                (17/08/2000) C.Paus
################################################################################
my($FILE) = ("EMPTY");
#-------------------------------------------------------------------------------
my($i) = (0);
#-------------------------------------------------------------------------------
$n = `basename $0`; chop($n); $h="$n>";
$home = $ENV{'HOME'} || $ENV{'LOGDIR'} || (getpwuid($<))[7] || die "No Home!\n";
$date = `date +'%y%m'`; chop($date);

if ($ARGV[0] eq "-h"  || $#ARGV != 0) { &show_documentation; die; }
#-------------------------------------------------------------------------------
$FILE = $ARGV[0];

printf "\n";
printf "FILE: $FILE\n";
printf "\n";

# Create the html header stuff

printf "<ul>\n";

# Get all eps files from the tex code

open (INPUT,"<$FILE");
while (<INPUT>) {

  if ($_ =~ m/file=(.*\.eps)/ && ! (/^%/)) {
    chop($_);
    printf "  <li> <a href=$1>Figure %d - $1</a>\n  </li>\n",++$i;
  }
  if ($_ =~ m/{(.*\.eps)/ && ! (/^%/)) {
    chop($_);
    my @f = split("{",$1);
    my $file = pop(@f);
    printf "  <li> <a href=$file>Figure %d - $file</a>\n  </li>\n",++$i;
  }

}

printf "</ul>\n";

exit 0;
