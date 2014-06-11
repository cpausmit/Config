#!/usr/bin/env perl
#---------------------------------------------------------------------------------------------------
# This script will automatically create an index of available galleries in the simpleview
# directories.
#
#---------------------------------------------------------------------------------------------------
use strict;

my $BASE = @ARGV[0];
my $cmd;
my $dir;
my $file;

$cmd = "find ./ -maxdepth 1 | grep ./20 | sort";
chdir($BASE);

&Header;

open (INPUT," $cmd | ");
while (<INPUT>) {
  chop($_);
  $dir = $_;
  $dir =~ s/.\///;
  #printf "DIR: $BASE/$dir\n";
  printf "<li> $dir:\n";
  opendir(DIR,"$BASE/$dir") || printf " cannot open $BASE/$dir\n";
  foreach $file (sort grep(/[0-9][0-9]/,readdir(DIR))) {
    #printf "subdir: $file\n";
    printf "  <a href=\"$dir/$file\">$file</a>\n";
  }
  closedir(DIR);
}

&Footer;

sub Header {
  print STDOUT "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML//EN\"> 
<html> 
<head><title>Photos from the PausHaus</title> 
<link href=\"paushaus-style.css\" rel=\"stylesheet\" type=\"text/css\">
</head> 
<h1>Photos from the PausHaus</h1>
<hr> 
 
<ul>\n
";
}

sub Footer {
  print STDOUT "
</ul> 
 
<hr> 
</body> 
</html>\n
";
}

exit 0;

