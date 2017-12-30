#!/usr/bin/env perl
use strict;
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
# Packages to install:  sudo yum install -y youtube-dl
#
#                                                                             Ch.Paus (Nov 06, 2011)
#                                                                 Version 1.0 Ch.Paus (Jan 28, 2014)
#                                                                 Version 2.0 Ch.Paus (Dec 30, 2017)
#===================================================================================================
my $DATABASE="$ENV{'HOME'}/Music";
my $PLAYLISTS="./PlayLists.txt";
my $REGEXP = "";
if ($ARGV[0] ne "") {
  $PLAYLISTS = "$ARGV[0]";
}
if ($ARGV[1] ne "") {
  $REGEXP = "$ARGV[1]";
}

sub getVideosOfPlaylist()
{
  # get list of videos for a given playlist
  my $plId = shift(@_); # the playlist Id as given by youtube

  my @urlList;
  my $cmd = "wget  -O - https://www.youtube.com/playlist?list=".$plId." 2>/dev/null | ".
      " grep 'a href=\"/watch?v='|".
      " sed -e 's#^.*<a href=\"/watch?v=#https://www.youtube.com/watch?v=#'".
      "     -e 's#\&amp;.*\$##'";
  
  my $fh;
  open($fh,'-|',$cmd) or die $!;
  while (my $line = <$fh>) {
    chop($line);
    push @urlList, $line;
  }
  
  return @urlList;
}

sub getTitleHashList()
{
  # make a hash list of the existing titles in the given subdirectory
  my $dir = shift(@_); # directory where files are stored == title of the playlist

  # make hash list of existing files
  my %hashList = {};
  opendir(DIR, $dir) or die $!;
  my @files = grep {!/^\./} readdir(DIR);
  
  for my $file (@files) {
    #print " Existing -- $file\n";
    my $hash = `cleanString.sh cleanContractBasename \"$file\"`;
    chop($hash);
    if (exists $hashList{$hash}) {
      #printf "\n Requesting existing spot: $hash -> $file (exists: $hashList{$hash})\n";
      my $cmd = " rm \"$dir/$file\"";
      #print(" Execute: $cmd\n\n");
      system($cmd);
    }
    else {
      $hashList{$hash} = "$file";
      #printf " Added hash: $hash -> $file\n";
    }
  }
  closedir(DIR);

  return %hashList;
}

sub downloadMissingTitles()
{
  # make a hash list of the existing titles in the given subdirectory
  my $dir =  $_[0];                   # directory where files are stored == title of the playlist
  my @urlList = @{$_[1]};             # list of video URLs
  my %existingTitlesHash = %{$_[2]};  # hash list of all already existing titles

  my $nDownloads = 0;

  # print the existing title hashes
  #printf " Existing hashes: \n";
  #while ( my ( $key, $value ) = each %existingTitlesHash ) { 
  #  printf " key: %s,  value: %s\n", $key,$value;
  #}
  
  chdir($dir);
  for my $videoUrl (@urlList) {
     
    my $videoId = $videoUrl;

    #printf " video: %s %s",$videoId,$videoUrl;

    $videoId =~ s/^(https?:\/\/www\.youtube\.com\/watch\?)(.*)?(v=[a-zA-Z0-9_\-]+)(.*)$/$3/;
    $videoId = substr($videoId,2);
    #printf "\nURL: $videoUrl -> $videoId\n";

    # get file name
    my $dl_cmd = "youtube-dl -o '%(title)s.%(ext)s' https://www.youtube.com/watch?v=$videoId";
    my $file = `$dl_cmd --get-filename 2> /dev/null`;
    chop($file);

    if ($file eq "") {
      printf " ERROR: finding filename for $videoUrl\n";
      next;
    }
	
    my $hash = `cleanString.sh cleanContractBasename \"$file\"`;
    chop($hash);

    # test whether file or something very similar exists already locally
    #printf " Testing hash -- file: $file  -->  $hash\n";
    if (exists $existingTitlesHash{$hash}) {
      #printf " Matching file already found: $hash -> $file (exists: $existingTitlesHash{$hash})\n";
      next;
    }
    else {
      print(" Execute: $dl_cmd\n\n");
      system($dl_cmd);
      $nDownloads += 1;
    }   
  }
  chdir("../");

  return $nDownloads;
}

#===================================================================================================
#                                                M A I N
#===================================================================================================

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
printf " Regular expression        : $REGEXP\n";

# Start the loop through the play lists

open (INPUT,"<$PLAYLISTS");
while (<INPUT>) {

  chop($_);

  my @f = split(" ",$_);

  # the two parameters needed
  my $dir  = $f[0];
  my $plId = $f[1];

  # looping through
  if ($REGEXP eq "" || $dir =~ /$REGEXP/) {
  
    if (! -d "$dir") {
      mkdir "$dir";
    }
    
    printf "\n============================================================\n";
    printf "  Next Playlist  -->  dir=$dir  plId=$plId\n";
    printf   "============================================================\n\n";
  
    # make a list of all URLs
    my @urlList = &getVideosOfPlaylist($plId);
    # find all already existing titles
    my %existingTitlesHash = &getTitleHashList($dir);
    # process the URLs in this list and download if needed
    my $nDownloads = &downloadMissingTitles($dir,\@urlList,\%existingTitlesHash);

    printf " Downloaded new titles: %d\n", $nDownloads;

  }
}

close(INPUT);

exit 0;
