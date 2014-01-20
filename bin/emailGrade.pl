#!/usr/bin/perl
use strict;
################################################################################
sub show_documentation {
  my $exit_status = shift@_;
  print "
  ACTION
  ======

    Send E-mail.

  SYNTAX
  ======
    email.pl  <person> <email> <final-score> <letter-grade>

";
  exit $exit_status;
}
#
# Called from user
#
# VERSION 0.0                                                 17/04/2001 Ch.Paus
################################################################################
my ($NAME,$EMAIL,$FINAL,$LETTER) = ("Chris","paus","-0","Invalid");
#-------------------------------------------------------------------------------

if ("$ARGV[0]" eq "-h") { &show_documentation(1); }

if    ($#ARGV == -1) { }
elsif ($#ARGV ==  3) { $NAME  = "$ARGV[0]"; $EMAIL  = "$ARGV[1]";
		       $FINAL = "$ARGV[2]"; $LETTER = "$ARGV[3]"; }
else                 { &show_documentation(2); }

open(OUT,">/tmp/letter.txt");
printf OUT "

Dear $NAME,

I have just returned from the Christmas vacation in Germany. After
some discussion during my vacation the grades are now final. Since
many of you asked I sent the missing grades to everybody. Your scores
are:

 $FINAL/180 in the final exam
 $LETTER as letter grade for the course for internal usage

My apologies for the late reply.

Cheers, Christoph

PS: Happy new year!!

";
close(OUT);

my $cmd;
$cmd = "mail -s '8.01 - Remaining Info' -c paus\@mit.edu $EMAIL\@mit.edu < /tmp/letter.txt";
printf "EMAIL: $cmd\n";
system("$cmd");

$cmd = "rm /tmp/letter.txt";
system("$cmd");

exit 0;
