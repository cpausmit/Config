#!/usr/bin/env perl
use strict;

my $SRC = @ARGV[0];
my $HTTP = "http://cpausmit.dyndns.org/~paus/photo";

my ($dir,$dir1,$dir2);
my $cmd;
my $file;
my $line;
my @f;

$cmd = "ls -1 $SRC";

my $lastYear = 0;
open(INPUT,"$cmd | grep ^20 |");
while ($line = <INPUT>) {
  chop($line);
  my $gallery = $line;
  my $year    = substr($line,0,4);
  my $period  = substr($line,4,20);
  if ("$year" ne "$lastYear") {
    ##printf "\n$year\n";
    $lastYear = $year;
  }
  else {
    ##printf",\n";
  }
  ##printf "<a href=\"../../$year/$period/index.html\">$period</a>";

  ####printf "createGallery.pl $SRC/$gallery /home/paus/Home/www/photo/$year/$period\n";

  $cmd = "wget -O test.bak $HTTP/$year/$period/buildgallery.php";
  printf "CMD: $cmd\n";
  system("$cmd");

}
##printf "\n";


# get last directories visible in http

exit 0;
