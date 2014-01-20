#!/usr/bin/perl
use strict;
################################################################################
sub show_documentation {
  my $exit_status = shift@_;
  print "
  ACTION
  ======

    Parse a given tex file and write out the cites in order of their
    appearance. Input or include files are not considered in this
    process. So keep your text in one fricking file ;-)

  SYNTAX
  ======

    texGetCites.pl  file

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
my ($file,$cite,$idx,$chunk);
my (@f,@c);
my (%stats);
#-------------------------------------------------------------------------------

if ("$ARGV[0]" eq "-h" || $#ARGV == -1) {
  &show_documentation(1);
}

foreach $file (@ARGV) {

  open(INPUT,"<$file");
  while (<INPUT>) {

    if (/\\cite{/) {
      chop($_);
      @f = split("cite{",$_);
      #printf "N: $#f - $_\n";
      shift(@f);
      foreach $chunk (@f) {
	$idx  = index($chunk,"}")-1;
	$cite = substr($chunk,0,index($chunk,"}"));
	@c    = split(",",$cite);
	foreach $cite (@c) {
	  if ("$stats{$cite}" eq "") {
	    #printf "$chunk: $chunk\n";
	    #printf STDERR "$cite\n";
	    printf STDOUT "\\bibitem{$cite}\n";
	    $stats{$cite} = "FOUND";
	  }
	}
      }
    }
  }
  close(INPUT);
}
  
exit 0;
