#!/usr/bin/env python
#
import os,sys
import rex
import urllib

def cleanup_line(line):
    # the printout needs to be cleaned up
    line = line.replace("<br>","\n")
    line = line.replace("&nbsp;"," ")
    line = line.replace("%``","``")
    
    return line

def print_source(tag):
    print "\n%% == NEXT %s =="%tag
    tag = urllib.quote(tag)
    myRex = rex.Rex()
    url = "http://inspirehep.net/search?ln=en&p=%s&of=hlxu&action_search=Search"%tag
    cmd = 'wget "%s" -O -'%(url)
    #print "CMD " + cmd
    (rc,out,err) = myRex.executeLocalAction(cmd)

    # parsing the tags is not elegant but it works
    print_on = False
    for line in out.split("\n"):
        if "</pre>" in line:
            print_on = False
        if print_on:
            line = cleanup_line(line)
            print line
        if "<pre>" in line:
            print_on = True
    

# url encode the string tag
for arg in sys.argv[1:]:
    print_source(arg)
