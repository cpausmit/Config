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
  my $nFigures = 0;
  my $inFigure = 0;
  my $caption = "";
  my $file = "";
  my $text = "";
  while (<INPUT>) {
    chop($_);

    if (/^%/) {
      printf " Skipping: ",$_;
      next;
    }

    if (/\\begin{figure/ && ! (/^%/)) {
      $inFigure = 1;
      $nFigures++;
      $text = "";
      $caption = "";
      $file = "";
    }

    if ($inFigure == 1) {
      $text = "$text $_";


      if (/\\includegraphics.*{(.*\.pdf)}/ && ! (/^%/)) {
        $file = "$file $1";
      }
      elsif ($_ =~ m/file=(.*\.pdf)/       && ! (/^%/)) {
        $file = "$file $1";
      }
    }

    if (/\\end{figure/ && ! (/^%/)) {
      $inFigure = 0;

      # contract white spaces
      $text =~ s/ +/ /g;
      $text =~ m/caption\{(.*?)\}/xg;
      $caption = "$1";

      printf "\n %d : $file\n $caption\n\n $text\n",$nFigures;

      $text = "";
      $caption = "";
      $file = "";
    }

      
  }
  close(INPUT);
}
  
exit 0;
