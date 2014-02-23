#!/usr/bin/env python
#----------------------------------------------------------------------------------------------------
# Check whether all files mentioned in the Playlist are actually available and suggest alternatives
# which have a different format.
#----------------------------------------------------------------------------------------------------
import sys, os, re, fnmatch

playList = "/external/userdata/playlists/video/WorkingAway.m3u"

if len(sys.argv)>=2:
    playList = sys.argv[1]
    
print '# Testing entries in playlist: ' + playList

for line in open(playList).readlines():
    line = line[:-1]
    file = line

    if line.startswith('#'):
        print line
        continue

    if os.path.exists(file):
        print file
    else:
        print '# File gone  : ' + file
        
        f = file.split('/')
        fileName = f.pop()
        dirName  = '/'.join(f)
        
        f = fileName.split('.')
        f.pop()
        trunc = '.'.join(f)

        for file in os.listdir(dirName):
            if fnmatch.fnmatch(file,trunc + '.*'):
                print dirName + '/' + file
                
sys.exit(0)
