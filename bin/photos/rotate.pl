#!/usr/bin/env perl
use strict;

my $ANGLE = pop(@ARGV);
my $PERC  = 70;
my $HTTP  = "http://cpausmit.dyndns.org/~paus/photo";
my $SRC   = "/home/paus/Home/photo";

my $cmd;
my @f;

my $TGT;

system("echo PERL angle $ANGLE >> /tmp/rotate.log");

for $TGT (@ARGV) {
  system("echo working on $TGT with angle $ANGLE >> /tmp/rotate.log");
  
  @f = split("/",$TGT);
  
  my $file   = pop(@f);
  my $test   = pop(@f);
  my $period = pop(@f);
  my $year   = pop(@f);
  
  system("echo FILE $file >> /tmp/rotate.log");

  if ("$test" ne "images") {
    print "ERROR - image is not in the expected area.\n";
    exit 0;
  }
  
  # Initializing
  my $SRCDIR = "/home/paus/Home/photo/${year}${period}";
  my $TGTDIR = "/home/paus/Home/www/photo/${year}/${period}";
  
  # Update orientation.txt
  open(IN, "</home/paus/Home/photo/${year}${period}/orientation.txt");
  open(OUT,">/tmp/orientation.txt");
  my $line;
  while ($line = <IN>) {
    if ($line =~ /$file/) {
      $line = "$file  -rotate $ANGLE\n";
      system("echo LINE $line >> /tmp/rotate.log");
    }
    print OUT "$line";
    print     "$line";
  }
  close(IN);
  close(OUT);
  
  open(TMP,">>/tmp/rotate.log");
  
  $cmd  = "sudo cp ";
  $cmd .= "/home/paus/Home/photo/${year}${period}/orientation.txt ";
  $cmd .= "/home/paus/Home/photo/${year}${period}/orientation.txt.bak; ";
  $cmd .= "sudo mv /tmp/orientation.txt ";
  $cmd .= "/home/paus/Home/photo/${year}${period}/orientation.txt";
  printf TMP "$cmd\n";
  system($cmd);
  
  # Remake the image and the thumbnail
  my $opt;
  $cmd = "grep ^$file /home/paus/Home/photo/${year}${period}/orientation.txt";
  open(IN,"$cmd |");
  while ($line = <IN>) {
    @f = split(" ",$line);
    shift(@f);
    $opt = join(" ",@f);
  }
  close(IN);
  
  $cmd = "convert $SRCDIR/$file $opt -thumbnail 200 $TGTDIR/thumbs/$file";
  printf TMP "  $cmd\n";
  system($cmd);
  $cmd = "convert $SRCDIR/$file $opt -resize $PERC% $TGTDIR/images/$file";
  printf TMP "  $cmd\n";
  system($cmd);
  close TMP;
  #system("cat /tmp/testRotate");
}
exit 0;
