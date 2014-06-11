#!/usr/bin/env perl
use strict;
#---------------------------------------------------------------------------------------------------
# This script will create all galleries from scratch or just starting from a given month and year.
#
#---------------------------------------------------------------------------------------------------
if ("$ARGV[0]" eq "-h") {
  printf "\n usage:  makeGalleries.pl <first month> <first year>\n\n";
  exit;
}

# Initial parameters
my $SCRIPT = "createGallery.pl";
my $ALBUM  = "/export/backup/data/cpAlbum"; 
my $WEBDIR = "/home/paus/www/photos"; 
my $FIRST_YEAR  = 2000;
my $FIRST_MONTH = 12;

# Command line parameters
my $MONTH = $FIRST_MONTH;
my $YEAR  = $FIRST_YEAR;
if ("$ARGV[0]" ne "") {
  $MONTH = $ARGV[0];
}
if ("$ARGV[1]" ne "") {
  $YEAR = $ARGV[1];
}

# Find present year and month
my $lastYear  = 2012;
my $lastMonth = 11;
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $lastYear  =  $year + 1900;
my $lastMonth =  $mon  + 1;

# Variables used throughout
my $cmd;
my $cmonth;
my $debug     = 0;
my $year      = $YEAR;
my $month     = $MONTH;

printf "Start at  $YEAR -> $MONTH\n";

# Loop through the requested years/months 
while ($year <= $lastYear) {
  while ($month <= 12 && ($year != $lastYear || $month <= $lastMonth)) {
    $cmonth = sprintf("%02d", $month);    
    $cmd = "$SCRIPT $ALBUM/$year/$cmonth $WEBDIR/$year/$cmonth";
    printf "$cmd\n";
    if ($debug == 0) {
      system("$cmd");
    }
    $month++;
  }
  $month = 1;
  $year++;
}

# Finally update the index overview page
$cmd = " makePhotoIndex.pl $WEBDIR > $WEBDIR/indexPhotos.html";
printf "$cmd\n";
if ($debug == 0) {
  system("$cmd");
}

exit 0;
