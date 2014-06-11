#!/usr/bin/env perl
#---------------------------------------------------------------------------------------------------
# This script will create a new gallery taking photos with their full resolution and scaling them
# down to an acceptable level for reasonably fast presentation per web browser.
#
#---------------------------------------------------------------------------------------------------
use strict;

my $SRC = @ARGV[0];
my $TGT = @ARGV[1];
my $OPT = @ARGV[2];

my $WIDTH    = 1000;
my $HTTP     = "http://paushaus.dyndns.org/photos";
my $TEMPLATE = "/home/paus/www/photos/template";

my ($dir,$dir1,$dir2,$cdir);
my $cmd;
my $file;
my @f;

# get last directories visible in http
@f = split('/',$TGT);
$dir1 = pop(@f);
$dir2 = pop(@f);
$dir = "$dir2/$dir1";
$cdir = "$dir2 -- $dir1";

if (-e "$SRC/orientation.txt") {
  printf "Configuration file for photo orientations exists.\n";
}
else {
  printf "Create configuration file for photo orientations.\n";
  $cmd  = "/bin/ls -1 $SRC | grep jpg > o.txt;";
  $cmd .= "sudo mv o.txt $SRC/orientation.txt";
  printf "$cmd\n";
  system($cmd);
}

if ("$OPT" eq "") {
  @f = split("/",$TGT); pop(@f);
  my $stub = join("/",@f);
  if (-d "$TGT") {
    printf "INFO: directory ($stub) already exists... update styles etc.\n";
    $cmd = "cp $TEMPLATE/index.html $TEMPLATE/buildgallery.php $TGT/";
    printf "UPDATE TEMPLATES: $cmd\n";
    system($cmd);
  }
  else {
    $cmd = "mkdir -p $stub";
    system("$cmd");
    # create copy of the template directory and set access right correctly
    $cmd = "cp -r $TEMPLATE $TGT";
    printf "COPY TEMPLATE: $cmd\n";
    system($cmd);
    $cmd = "chmod 777 $TGT/gallery.xml $TGT/thumbs";
    printf "ADJUST ACCESS: $cmd\n";
    system($cmd);
  }
}

opendir(DIR,"$SRC") || printf " cannot open $SRC\n";
foreach $file (grep(/\.jpg$/,readdir(DIR))) {
    my $opt = `grep $file $SRC/orientation.txt`; chop $opt;
    @f = split(" ",$opt); shift(@f);
    $opt = join(" ",@f);
    printf "jpg file: $file (options: $opt)\n";
    # make the new thumbnail
    if (-e "$TGT/thumbs/$file") {
      printf " Thumbnail already exists.\n";
    }
    else {
      $cmd = "convert $SRC/$file $opt -thumbnail 200 $TGT/thumbs/$file";
      printf "  $cmd\n";
      system($cmd);
    }
    # make the new image
    if (-e "$TGT/images/$file") {
      printf " Picture already exists.\n";
    }
    else {
      $cmd = "convert $SRC/$file $opt -resize $WIDTH $TGT/images/$file";
      printf "  $cmd\n";
      system($cmd);
    }
}
closedir(DIR);

if ($OPT eq '') {
  printf "Update title for the gallery.\n";
  $cmd  = "cd $TGT; repstr \"XX--TITLE--XX\" \"$dir\" buildgallery.php gallery.xml index.html";
  system($cmd);
  $cmd  = "cd $TGT; chmod 777 gallery.xml";
  system($cmd);
}

$cmd = "wget $HTTP/$dir/buildgallery.php -O test.txt; rm test.txt";
printf "GENERATE GALLERY: $cmd\n";
system($cmd);

exit 0;
