#!/usr/bin/env perl
use strict;
no strict 'refs';
use List::MoreUtils qw(each_array);
#---------------------------------------------------------------------------------------------------
#
# Script for sending a mildly customized e-mail to a list of people, like referees, advisors,
# students, reviewers etc..  Replacing the named keys in the termplate e-mail.
#
# Dependencies: perl is needed in particular: perl-List-AllUtils
#
#               -- yum install -y  sendmail perl perl-List-AllUtils
#                  sudo service    sendmail start
#
# To do: the current version is doing what it is supposed to do but it is a terrible piece of code
#        major re-write needs to be done getting ride of perl special packages and making it clean
#        and modular. Maybe I should just rewrite it in python?!  ;-)
#
#                                                       Version 1.0:   Jan 28, 2014 (Christoph Paus)
#                                                             Written: Aug 25, 2009 (Christoph Paus)
#---------------------------------------------------------------------------------------------------
# default for command line parameters
my ($project,$template) = ("8.02","5thWeekFlag.txt");
# these are tags that can be set inside of the eemail template
my ($subject,$cc,$replyTo) = ("","","");
# additional things to specify
my ($DEBUG) = (0);

#---------------------------------------------------------------------------------------------------
my ($line,$cmd);
my ($recipientEmail);
my (@f,@g,$tag,$counts,%counts);

if ("$ARGV[0]" ne "") {
  $project = "$ARGV[0]";
}
if ("$ARGV[1]" ne "") {
  $template = "$ARGV[1]";
}

printf "\n Project : $project\n";
printf " Template: $template\n";

if (! (-e "$project/spool")) {
  system("mkdir -p $project/spool");
}

# Look through template file for tags
my @tags = ();
open(INPUT,"cat $project/$template | grep -v ^# |");
while (<INPUT>) {
  chop($_);
  if ($DEBUG) {
    printf "$_\n";
  }
  push(@tags,m/XX-(.+?)-XX/g);
}
close(INPUT);

# Go through and remove duplicates
my %counts = {};
foreach $tag (@tags) {
  if ($DEBUG) {
    printf "TAG: $tag\n";
  }
  if (".$counts{$tag}" eq ".") {
    $counts{$tag} = 1;
  }
  else {
    $counts{$tag} += 1;
  }
}

# Loop through unique tags
printf "\n Required tags from email template:\n";
foreach $tag ( keys %counts ) {
  if ($counts{$tag} ne "") {
    printf "  -->  ($counts{$tag}) $tag\n";
  }
}
printf "\n";

# Process each line in the setup file
my $first = 0;
my @keys  = ();
#open(INPUT,"cat $project/emailParameters.txt | grep -v ^# |");
open(INPUT,"cat $project/emailParameters.csv | grep -v ^# |");
while($line = <INPUT>) {

  chop($line);
  if ($DEBUG != 0) {
    printf "LINE: $line\n";
  }

  # split the line into its fields
  @f = split(':',$line);
  #@f = split(',',$line);
  
  # make sure to reset the values per line
  my @values = ();
  for my $value (@f) {
    $value =~ s/^\s+//;
    $value =~ s/\s+$//;
    # first line is just about the keys
    if ($first == 0) {
      push(@keys,$value);
    }
    # every other line contains values matching to the keys
    else {
      push(@values,$value);
    }
  }

  # first line is the definition
  if ($first == 0) {
    processFirstLine($line,%counts);
    $first = 1;
  }
  # these are lines which will result in an email
  else {

    # setup recipient e-mail
    for (my $i=0; $i<@keys; $i=$i+1) {
	if ($keys[$i] eq "EMAIL") {
          $recipientEmail = $values[$i];
          if ($DEBUG != 0) {
            printf " Email: $recipientEmail\n";
          }
        }
      $_ =~ s/XX-$keys[$i]-XX/$values[$i]/;
    }

##     $recipientEmail = $values[0];
##     if ($DEBUG != 0) {
##       printf " Email: $recipientEmail\n";
##     }

    if ($recipientEmail ne "") {
      # step one: create specific raw email and make all personal
      open(OUTPUT,"> $project/spool/${recipientEmail}_${template}.eml-raw");
      open(PARSE, "$project/$template");
      while (<PARSE>) {
        for (my $i=0; $i<@keys; $i=$i+1) {
  	$_ =~ s/XX-$keys[$i]-XX/$values[$i]/;
        }
        printf OUTPUT "$_";
      }
      close(PARSE);
      close(OUTPUT);
      
      # step two: extract additional email command line directions and remove them from raw file
      open(OUTPUT,"> $project/spool/${recipientEmail}_${template}.eml");
      open(PARSE, "$project/spool/${recipientEmail}_${template}.eml-raw");
      while (<PARSE>) {
        if (m/^subject:/i) {
  	chop($_);
  	@f = split(':',$_);
  	$tag = shift(@f);
  	$subject = join(':',@f);
  	$subject =~ s/^\s+//;
  	printf " Found subject tag ($tag): $subject\n";
        }
        elsif (m/^replyto:/i) {
  	chop($_);
  	@f = split(':',$_);
  	$tag = shift(@f);
  	$replyTo = join(':',@f);
  	$replyTo =~ s/^\s+//;
  	printf " Found replyto tag ($tag): $replyTo\n";
        }
        elsif (m/^cc:/i) {
  	chop($_);
  	@f = split(':',$_);
  	$tag = shift(@f);
  	$cc = join(':',@f);
  	$cc =~ s/^\s+//;
  	printf " Found carbon-copy tag  ($tag): $cc\n";
        }
        else {
  	printf OUTPUT "$_";
        }
      }
      close(PARSE);
      close(OUTPUT);
  
      # remove the raw eml file
      system("rm $project/spool/${recipientEmail}_${template}.eml-raw");
      
      # finally produce the command line to send the email (email is not send by the tool)
      $cmd  = "mail -s '$subject'";
      if ("$cc" ne "") {
        $cmd .= " -c $cc"; 
      }
      if ("$replyTo" ne "") {
        $cmd .= " -S replyto=$replyTo";
      }
      $cmd .= " $recipientEmail <  $project/spool/${recipientEmail}_${template}.eml\n";
      printf "\n $cmd\n";
    }

  }
}
close(INPUT);

#---------------------------------------------------------------------------------------------------
# some subroutines to make it easier
#---------------------------------------------------------------------------------------------------
sub processFirstLine {

  my $line   = shift(@_);
  my %counts = @_;

  my @keys = split(':',$line);
  for my $value (@keys) {
    $value =~ s/^\s+//;
    $value =~ s/\s+$//;
  }
  
  if (shift(@keys) ne "EMAIL") {
    printf "\n ERROR - first line in first column has to be EMAIL\n";
  }
  printf "\n Keys from email parameter list:\n";
  foreach my $key (@keys) {
    printf "  -->  $key\n";
  }

  # quick check whether we have unresolved keys
  use List::MoreUtils qw{any};
  printf "\n Checking whether all requested keys are specified\n";
  foreach my $key ( keys %{ %counts } ) {
    my $found = 0;
    foreach my $value (@keys) {
      if ("$value" == "$key") {
	$found = 1;
	last;
      }
    }
    if ($found == 0) {
      printf " ERROR - did not find requested key: $key\n";
      printf "         fix email parameters file!\n";
      exit 0;
    }
  }
  printf "\n SUCCESS -- all requested keys found let's generate the e-mails.\n";
  printf "\n";
  
  return;
}
