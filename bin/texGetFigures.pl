#!/usr/bin/perl
use strict;
####################################################################################################
sub show_documentation {
  my $exit_status = shift@_;
  print "
  ACTION
  ======

    Parse a given tex file and write out the eps files which are used
    as pictures within the document.

  SYNTAX
  ======

    texGetFigures.pl  file1 [ file2 [ file3 ... ] ]

      file = is a latex file

";
  exit $exit_status;
}
#
# Called from user
#
# VERSION 0.0                                                         07/21/2015 Christoph M.E. Paus
####################################################################################################
#---------------------------------------------------------------------------------------------------
my ($file,$fake,$cite,$idx,$chunk,$i);
my (@f,@c);
my (%stats);
my ($figLocation) = ("/home/paus/t3/public_html/exo-12-055");
my ($twikiLocation) = ("https://twiki.cern.ch/twiki/pub/CMS/Exo12055TWiki");
#---------------------------------------------------------------------------------------------------
if ("$ARGV[0]" eq "-h" || $#ARGV == -1) {
  &show_documentation(1);
}
#---------------------------------------------------------------------------------------------------
# some subroutines to make it easier
#---------------------------------------------------------------------------------------------------
sub cleanCaption {

  my $caption   = shift(@_);

  # cleanup the caption
  my $idx = 0;
  my $level = 1;
  while ($level > 0) {
  	# find the index to the next bracket
    my $idxOpen  = index(substr($caption,$idx),'{');
    my $idxClose = index(substr($caption,$idx),'}');
  	if ($idxOpen != -1 && $idxOpen<$idxClose) {
      $level++;
      $idx = $idx + $idxOpen + 1;
    }
  	else {
      $level--;
  	  if ($level == 0) {
  	    $idx = $idx + $idxClose - 1;
  	  }
  	  else {
  	    $idx = $idx + $idxClose + 1;
  	  }
    }
  }
  $caption = substr($caption,0,$idx+1);

  # remove label
  my $iBegin = index($caption,'\label{');
  my $iEnd = $iBegin + 7;
  if ($iBegin != -1) {
    
    my $idx = $iEnd;
    my $level = 1;
  
    while ($level > 0) {
      # find the index to the next bracket
      my $idxOpen  = index(substr($caption,$idx),'{');
      my $idxClose = index(substr($caption,$idx),'}');
      if ($idxOpen != -1 && $idxOpen<$idxClose) {
        $level++;
        $idx = $idx + $idxOpen + 1;
      }
      else {
        $level--;
	$idx = $idx + $idxClose + 1;
      }
    }
  
    printf "iBegin = %d,  iEnd: %d\n",$iBegin,$idx;
    my $start = substr($caption,0,$iBegin);
    my $end = substr($caption,$idx);
    printf " update: OLD\n $caption\n NEW \n$start $end\n";
    $caption = "$start $end";
  }
  
  return $caption;   
}


# letters for subfigure
my @subFigures = ("a","b","c","d","e","f","g","h","i","j");

$i = 0;

# global counter for all figures
my $nFigures = 0;

# set the global link in the TWiki
printf "<!--\n   * Set CDS = http://cdsweb.cern.ch/record\n   * Set SRC = ";
printf "https://twiki.cern.ch/twiki/pub/CMS/Exo12055TWiki\n-->\n\n";


# loop over all files in the tex
foreach $file (@ARGV) {
  open(INPUT,"<$file");
  # are we inside the figure environment
  my $inFigure = 0;
  # get the caption of the figure environment
  my $caption = "";
  # list the files and the links
  my @files = ();
  my @links = ();
  # grab the entire text for comparison
  my $text = "";
  # 
  my $baseFile;
  while (<INPUT>) {
    chop($_);

    if (/^%/) {
      printf " Skipping: $_\n";
      next;
    }

    if (/\\begin{figure/ && ! (/^%/)) {
      $inFigure = 1;
      $nFigures++;
      $text = "";
      $caption = "";
      @files = ();
      @links = ();
    }

    if ($inFigure == 1) {
      $text = "$text $_";

      if (/\\includegraphics.*{(.*\.pdf)}/ || /\\includegraphics.*{(.*\.png)}/ ) {
	@f = split("/",$1);
	$baseFile = pop(@f);   
        push(@files,"$1");
        push(@links,"%SRC%/$baseFile");
      }
      elsif ($_ =~ m/file=(.*\.pdf)/       || $_ =~ m/file=(.*\.png)/) {
	@f = split("/",$1);
	$baseFile = pop(@f);   
        push(@files,"$1");
        push(@links,"%SRC%/$baseFile");
      }
    }

    # Figure  environment finished here now show what we have collected
    if (/\\end{figure/ && ! (/^%/)) {
      # first switch off parsing
      $inFigure = 0;

      # contract white spaces
      $text =~ s/ +/ /g;
      # extract caption now
      $text =~ m/\\caption\{(.*)\}/xg;
      $caption = "$1";
      $caption = cleanCaption($caption);
      
      # loop over all files (subfigures) in this figure
      $i = 0;
      foreach $fake (@files) {

	# construct the various files and links we need
        my $invert = 0;
	my $file = ""; my $pngFile = "";
	my $link = ""; my $pngLink = "";
        if (@files[$i] =~ m/\.pdf/) {
	  $file = @files[$i]; $pngFile = $file; $pngFile =~ s/.pdf/.png/;
	  $link = @links[$i]; $pngLink = $link; $pngLink =~ s/.pdf/.png/;
	}
	else {
	  $invert = 1;
	  $file = @files[$i]; $pngFile = $file; $pngFile =~ s/.png/.pdf/;
	  $link = @links[$i]; $pngLink = $link; $pngLink =~ s/.png/.pdf/;
	}	  

	# print the summary
	printf "\n\n ==== Figure %d %s\n",$nFigures,@subFigures[$i];
	my $cmd1 = "convert $file $pngFile";
	my $cmd2 = "cp $file $pngFile $figLocation";
	system("$cmd1; $cmd2");
	printf " $cmd1\n $cmd2\n\n";

	# print the line of the table
        if ($invert == 0) {
    	  printf "| [[$link][<img width=\"300\"src=\"$pngLink\"/>]] ";
  	  printf "| Figure %d %s [[$link][pdf]] [[$pngLink][png]] ",$nFigures,@subFigures[$i];
  	  printf "| $caption |\n";
	}
	else {
    	  printf "| [[$link][<img width=\"300\"src=\"$link\"/>]] ";
  	  printf "| Figure %d %s [[$pngLink][pdf]] [[$link][png]] ",$nFigures,@subFigures[$i];
  	  printf "| $caption |\n";
	}	    
	$i++;
      }
    }
  }
  close(INPUT);
}
  
exit 0;
