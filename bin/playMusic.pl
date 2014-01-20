#!/usr/bin/env perl
use strict;

my $FILE   = $ARGV[0];
my $name   = "";
my $cd     = "";
my $artist = "";

if (-e "$FILE") {
  open (PLAYLIST,"<$FILE");
  while (<PLAYLIST>) {
    my $song = $_;
    chop($song);

    if (m/^#/) {
      #printf "Comment: $song\n";
    }
    else {
      if ("$song" =~ m#http://#) {
	#printf "downloading URL: $song to /tmp\n";
	my $line = $song;
	$line   =~ s/%20/ /g; $line =~ s/%27/'/g;
	my @f   = split("/",$line);
	$name   = pop(@f);
	$cd     = pop(@f);
	$artist = pop(@f);
	printf "-> $artist [$cd] with \"$name\" - loading";
	my $rc = system("wget $song -O /tmp/song.mp3 2> /dev/null");
	$song = "/tmp/song.mp3";
	if ($rc != 0) {
	  printf ".. interrupted!\n";
	  next;
	}
      }
      else {
	printf "Song: $song";
      }
      printf " playing\n";
      my $rc = system("sleep 2; realplay -q \"$song\"");
      if ("$song" =~ m#^/tmp#) {
	#printf "Delete file from /tmp directory ($song)\n";
	#system("rm $song");
      }
      if ($rc != 0) {
	exit 1;
      }
    }
  }
  close(PLAYLIST);
}
else {
  printf "Playlist does not exist.\n";
  exit 1;
}
