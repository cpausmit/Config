#!/usr/bin/perl
use strict;
################################################################################
sub show_documentation {
  my $exit_status = shift@_;
  print "
  ACTION
  ======

    Parse a given tex file and write out the eps files which are used
    as pictures within the document.

  SYNTAX
  ======

    texGetEpsFiles.pl  file

      file = is a latex file

";
  exit $exit_status;
}
#
# Called from user
#
# VERSION 0.0                                     22/06/2002 Christoph M.E. Paus
################################################################################
#-------------------------------------------------------------------------------
my ($file,$cite,$idx,$chunk,$i);
my (@f,@c);
my (%stats);
#-------------------------------------------------------------------------------
if ("$ARGV[0]" eq "-h" || $#ARGV == -1) {
  &show_documentation(1);
}

$i = 0;

foreach $file (@ARGV) {
  open(INPUT,"<$file");
  while (<INPUT>) {
    chop($_);
    if (/\\includegraphics.*{(.*\.eps)}/ && ! (/^%/)) {
      printf "%3d - $1\n",++$i;
    }
    elsif ($_ =~ m/file=(.*\.eps)/       && ! (/^%/)) {
      printf "%3d - $1\n",++$i;
    }
  }
  close(INPUT);
}
  
exit 0;
