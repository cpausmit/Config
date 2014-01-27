#!/usr/bin/env perl
use strict;
use Web::Scraper;
use URI;
#===================================================================================================
#
# Script to automatically syncronize our local database with a list of playlists that we are
# maintaining on youtube. This little script is based on a nice script ytplaylistfetcher which
# is free software. The beauty of course is that a video that has alread been downloaded will
# not be downloaded again. So just incremental changes will be applied, avoiding long download
# times.
#
#  Packages to install:  ytplaylistfetcher (somewhere from the web)
#
#                        - sudo yum install -y cclive clive lynx perl-Getopt-Long-Descriptive \
#                                              perl-Web-Scraper  perl-LWP-Protocol-https \
#                                              youtube-dl
#
#                        - mkdir $USER/Tools
#                        - cd    $USER/Tools
#                        - git clone git://git.carbon-project.org/ytplaylistfetcher.git
#
#
#                                                                             Ch.Paus (Nov 06, 2011)
#===================================================================================================
my $DATABASE="$ENV{'HOME'}/Music";
my $PLAYLISTS="./PlayLists.txt";
if ("$ARGV[0]" != "") {
	$PLAYLISTS="$ARGV[0]";
}

# Is the List of PlayList really there?
if (-e "$PLAYLISTS") {
	printf " List of playlists (exists): $PLAYLISTS\n";
}
else {
	printf " ERROR -- list of playlists ($PLAYLISTS) does not exist. EXIT!\n";
	exit 1;
}

# Do we have a database directory?

if (-d "$DATABASE") {
	printf " Database          (exists): $DATABASE\n";
}
else {
  printf " ERROR -- database does not exist. EXIT!\n";
	exit 1;
}

# Start the loop through the play lists

open (INPUT,"<$PLAYLISTS");
while (<INPUT>) {

	chop($_);

	my @f = split(" ",$_);

	my $dir  = $f[0];
	my $plId = $f[1];
	
	printf "LINE - $_ -->  dir=$dir  plId=$plId\n";


	my $oUri = URI->new('https://www.youtube.com/playlist?list='.$plId) ||
			printf " ERROR -- Could not create URL object!  EXIT!\n";

	my $oVideos = scraper {process '//a[contains(@class,"ux-thumb-wrap yt-uix-sessionlink")]',
												 "videos[]" => '@href';
	};

	my $results = $oVideos->scrape($oUri);

	foreach my $videoUrl (@{$results->{videos}}) {

		my $videoId = $videoUrl;
		$videoId =~ s/^(https?:\/\/www\.youtube\.com\/watch\?)(.*)?(v=[a-zA-Z0-9_\-]+)(.*)$/$3/;
		$videoId = substr($videoId,2);
		
		printf "URL: $videoUrl -> $videoId\n";

		my $DL_CMD = "youtube-dl -o '%(title)s.%(ext)s' https://www.youtube.com/watch?v=$videoId";
		printf " DOWLOAD: $DL_CMD\n";
	}

#
#  dir=`   echo $line | tr -s ' ' | cut -d ' ' -f1`
#  pLstId=`echo $line | tr -s ' ' | cut -d ' ' -f2`
#
#
#  # The meat: do the synchronization
#
#  echo ""
#  echo " Synchronizing playlist: $dir (id: $pLstId) "
#  mkdir -p $DATABASE/$dir
#  cd       $DATABASE/$dir
#  echo " ytplaylistfetcher -d http://www.youtube.com/playlist?list=$pLstId >& sync.log"
#  echo " Execute:  ytplaylistfetcher -d  http://www.youtube.com/playlist?list=$pLstId"  > sync.log
#  echo " "                                                                             >> sync.log
#  #ytplaylistfetcher -d http://www.youtube.com/playlist?list=$pLstId                    >> sync.log
#
#
#  
#done < $PLAYLISTS

}

close(INPUT);

exit 0;
