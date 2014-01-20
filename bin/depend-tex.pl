#!/usr/bin/perl
use strict;
################################################################################
sub show_documentation {
  my $exit_status = shift@_;
  print "
  ACTION
  ======
    Investigate all dependencies of a tex file concerning the
    eps/ps/pdf/png/jpg input files. Key is that the .log file lists those
    files as:

      <this_file.eps>   etc.

  SYNTAX
  ======
    depend-tex.pl  files

      files = are the files to be checked for dependencies

";
  exit $exit_status;
}
#
# Called from user
#
# VERSION 0.0                                     12/12/1998 Christoph M.E. Paus
################################################################################
my ($file, $line, $input);
my (@f);
#-------------------------------------------------------------------------------

if ("$ARGV[0]" eq "-h" || $#ARGV == -1) {
  &show_documentation(1);
}

foreach $file (@ARGV) {

#  printf "Parse file: $file\n";
  $file =~ tr/./ /;
  @f = split(' ',$file);
  $file = "$f[0].log";
#  printf "New file: $file\n";

  printf "$f[0].dvi:";
  open(INPUT,"<$file");
  while ($line = <INPUT>) {
    if ($line =~ /File:/ && ($line =~ /\.ps/ || 
        $line =~ /\.eps/ || $line =~ /\.png/ ||
        $line =~ /\.pdf/ || $line =~ /\.jpg/) ) {
      @f = split(' ',$line);
      if ($f[0] =~ /^%/) {
      }
      else {
	printf "\\\n";
	printf "$f[1]";
      }
    }
    elsif ($line =~ / \(/ && ($line =~ /\.tex/) ) {
      @f = split(' ',$line);
      $f[0] =~ tr/\(\)//d;
      if ($f[0] =~ /^%/) {
      }
      else {
	printf "\\\n";
	printf "$f[0]";
      }
    }
  }
  printf "\n";
  close(INPUT);
}

exit 0;
