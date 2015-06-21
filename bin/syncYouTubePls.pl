#!/usr/bin/env perl
use strict;
use Web::Scraper;
use URI;
#===================================================================================================
#
# Script to automatically syncronize our local database with a list of playlists that we are
# maintaining on youtube. This little script is based on an existing script ytplaylistfetcher
# which is free software but really dod not do the job I wanted done. So I wrote my own and
# rely now only on 'youtube-dl' a relatively well maintained tool to download youtube videos.
#
# The beauty of course is that a video that has already been downloaded will not be downloaded
# again. So just incremental changes will be applied, avoiding long download times.
#
# Packages to install:  sudo yum install -y cclive clive lynx perl-Getopt-Long-Descriptive \
#                                           perl-Web-Scraper  perl-LWP-Protocol-https \
#                                           youtube-dl
#
#                                                                             Ch.Paus (Nov 06, 2011)
#                                                                 Version 1.0 Ch.Paus (Jan 28, 2014)
#===================================================================================================
my $DATABASE="$ENV{'HOME'}/Music";
my $PLAYLISTS="./PlayLists.txt";
if ("$ARGV[0]" != "") {
  $PLAYLISTS="$ARGV[0]";
}

# Do we have a database directory?

if (-d "$DATABASE") {
  printf " Database          (exists): $DATABASE\n";
}
else {
  printf " ERROR -- database does not exist. EXIT!\n";
  exit 1;
}

# Is the List of PlayList really there?

if (-e "$PLAYLISTS") {
  printf " List of playlists (exists): $PLAYLISTS\n";
}
else {
  printf " ERROR -- list of playlists ($PLAYLISTS) does not exist. EXIT!\n";
  exit 1;
}

# Start the loop through the play lists

open (INPUT,"<$PLAYLISTS");
while (<INPUT>) {

  chop($_);

  my @f = split(" ",$_);

  my $dir  = $f[0];
  if (! -d "$dir") {
    mkdir "$dir";
  }
  my $plId = $f[1];
  
  printf "\n============================================================\n";
  printf "  Next Playlist  -->  dir=$dir  plId=$plId\n";
  printf   "============================================================\n\n";

  my $oUri = URI->new('https://www.youtube.com/playlist?list='.$plId) ||
      printf " ERROR -- Could not create URL object!  EXIT!\n";
  my $oVideos = scraper { process '//a[contains(@class,"ux-thumb-wrap yt-uix-sessionlink")]',
                          "videos[]" => '@href'; };
  my $results = $oVideos->scrape($oUri);

  # make list of existing files
  my %existingTitlesHash = {};
  opendir(DIR, $dir) or die $!;
  my @files = grep {!/^\./} readdir(DIR);

  for my $file (@files) {
    print " Existing -- $file\n";
    my $hash = `cleanString.sh cleanContractBasename \"$file\"`; chop($hash);
        if (exists $existingTitlesHash{$hash}) {
      printf "\n Requesting already filled spot: $hash -> $file (exists: $existingTitlesHash{$hash})\n";
      my $cmd = " rm \"$dir/$file\"";
      print(" Execute: $cmd\n\n");
      system($cmd);
    }
    else {
      $existingTitlesHash{$hash} = "$file";
      printf " Added hash: $hash -> $file\n";
    }
  }
  closedir(DIR);

  # process the URLs in this list and download if needed
  chdir($dir);
   foreach my $videoUrl (@{$results->{videos}}) {

     my $videoId = $videoUrl;

     $videoId =~ s/^(https?:\/\/www\.youtube\.com\/watch\?)(.*)?(v=[a-zA-Z0-9_\-]+)(.*)$/$3/;
     $videoId = substr($videoId,2);
     
     printf "\nURL: $videoUrl -> $videoId\n";

    # get file name
     my $dl_cmd = "youtube-dl -o '%(title)s.%(ext)s' https://www.youtube.com/watch?v=$videoId";
     my $file = `$dl_cmd --get-filename`;  chop($file);
     my $hash = `cleanString.sh cleanContractBasename \"$file\"`; chop($hash);

    # test whether file or something very similar exists already locally
     printf " Testing hash: $hash  -->  file: $file\n";

     if (exists $existingTitlesHash{$hash}) {
       printf " Matching file already found: $hash -> $file (exists: $existingTitlesHash{$hash})\n";
     }
    else {
      print(" Execute: $dl_cmd\n\n");
      system($dl_cmd);
    }
     
   }
  chdir("../");

}

close(INPUT);

exit 0;
