#!/usr/bin/env perl
use strict;

my $SRC = @ARGV[0];
my $TGT = @ARGV[1];
my $OPT = @ARGV[2];

my $PERC = 70;
my $HTTP = "http://cpausmit.dyndns.org/~paus/photo";
my $TEMPLATE = "/home/paus/Home/www/photo/template";
my ($dir,$dir1,$dir2);
my $cmd;
my $file;
my @f;

# get last directories visible in http
@f = split('/',$TGT);
$dir1 = pop(@f);
$dir2 = pop(@f);
$dir = "$dir2/$dir1";

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
  $cmd = "mkdir -p $stub";
  system("$cmd");
  # create copy of the template directory and set access right correctly
  $cmd = "cp -r $TEMPLATE $TGT";
  printf "COPY TEMPLATE: $cmd\n";
  system($cmd);
  $cmd = "chmod 777 $TGT/gallery.xml $TGT/thumbs";
  printf "COPY TEMPLATE: $cmd\n";
  system($cmd);
}

opendir(DIR,"$SRC") || printf " cannot open $SRC\n";
foreach $file (grep(/\.jpg$/,readdir(DIR))) {
    my $opt = `grep $file $SRC/orientation.txt`; chop $opt;
    @f = split(" ",$opt); shift(@f);
    $opt = join(" ",@f);
    printf "jpg file: $file (options: $opt)\n";
    $cmd = "convert $SRC/$file $opt -thumbnail 200 $TGT/thumbs/$file";
    printf "  $cmd\n";
    system($cmd);
    $cmd = "convert $SRC/$file $opt -resize $PERC% $TGT/images/$file";
    printf "  $cmd\n";
    system($cmd);
}
closedir(DIR);

if ($OPT eq '') {
  $cmd  = "xemacs $TGT/index.html $TGT/buildgallery.php;";
  $cmd .= " cp $TGT/index.html $TEMPLATE/index.html";
  printf "EDIT DETAILS: $cmd\n";
  #system($cmd);
}

$cmd = "wget $HTTP/$dir/buildgallery.php -O test.txt; rm test.txt";
printf "GENERATE GALLERY: $cmd\n";
system($cmd);

exit 0;
