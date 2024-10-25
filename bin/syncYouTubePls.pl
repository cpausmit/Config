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
#                       most up-to-date at: https://github.com/ytdl-org/youtube-dl
#
#                                                                             Ch.Paus (Nov 06, 2011)
#                                                                 Version 1.0 Ch.Paus (Jan 28, 2014)
#                                                                 Version 2.0 Ch.Paus (Dec 30, 2017)
#===================================================================================================
my $YOUTUBE_DL = "youtube-dl";
my $DATABASE   = "$ENV{'HOME'}/Music";
my $PLAYLISTS  = "./PlayLists.txt";
##my $PLAYLISTS  = "./Test.txt";
my $REGEXP     = "";

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
  my $cmd = "wget  -O - https://www.youtube.com/playlist?list=".$plId." 2>/dev/null".
      " | sed -e 's#\"url\":#\\nNEXT#g'".
      " | grep watch?v=".
      " | sed 's#NEXT\"#https://www.youtube.com#'".
      " | grep www.youtube";

#      " | sed -e 's#/watch?v=\(.*\)u0026#https://www.youtube.com/watch?v=\1u0026#'".
#      " | grep https | sed 's#.*https://#https://#' ";

  #print("$cmd");
  
  my $fh;
  open($fh,'-|',$cmd) or die $!;
  while (my $line = <$fh>) {
    my @f = split(/\\/,$line);
    #print "Video: $f[0]\n";
    chop($line);
    push @urlList, $f[0];
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
  
  chdir($dir);
  for my $videoUrl (@urlList) {
     
    my $videoId = $videoUrl;

    #printf " video: %s %s",$videoId,$videoUrl;

    $videoId =~ s/^(https?:\/\/www\.youtube\.com\/watch\?)(.*)?(v=[a-zA-Z0-9_\-]+)(.*)$/$3/;
    $videoId = substr($videoId,2);
    #printf "\nURL: $videoUrl -> $videoId\n";

    # get file name
    my $dl_cmd = "$YOUTUBE_DL -o '%(title)s.%(ext)s' https://www.youtube.com/watch?v=$videoId";
    #printf("$dl_cmd\n");
    my $file = `$dl_cmd --get-filename 2> /dev/null`;
    #print "$dl_cmd --get-filename";
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

sub processListOfPlaylists()
{
  # get list of videos for a given playlist
  my $listFile = shift(@_); # the file name of the list of playlists
  my $regexp = shift(@_);   # regular expression to determine the mathcing list names

  open (INPUT,"<$listFile");
  while (<INPUT>) {
  
    chop($_);
  
    my @f = split(" ",$_);
  
    # the two parameters needed
    my $dir  = $f[0];
    my $plId = $f[1];
  
    # looping through
    if ($regexp eq "" || $dir =~ /$regexp/) {
    
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
  
  return;
}

#===================================================================================================
#                                                M A I N
#===================================================================================================

# Do we have youtube-dl?
my $rc = system("$YOUTUBE_DL -help >& /dev/null");
if ($rc != 0) {
  printf("\n ERROR - youtube download package not installed? (test: $YOUTUBE_DL)\n");
  printf("  ++ TRY ++  sudo dnf install -y youtube-dl\n\n");
  exit -1;
}
else {
  printf " Youtube download  (exists): $YOUTUBE_DL\n";
}

# Do we have a database directory?
if (-d "$DATABASE") {
  printf " Database          (exists): $DATABASE\n";
}
else {
  printf " ERROR -- database does not exist. EXIT!\n";
  exit 1;
}

# sanity checks and printouts of what is going to happen
if (-e "$PLAYLISTS") {
  printf " List of playlists (exists): $PLAYLISTS\n";
}
else {
  printf " ERROR -- list of playlists ($PLAYLISTS) does not exist. EXIT!\n";
  exit 1;
}
printf " Regular expression        : $REGEXP\n";

# process the list of playlists
&processListOfPlaylists($PLAYLISTS,$REGEXP);

exit 0;
