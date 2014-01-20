#!/usr/bin/env python
#---------------------------------------------------------------------------------------------------
# Script to all hosts in our MIT network configuration.
#
# Author: C.Paus                                                                (September 23, 2008)
#---------------------------------------------------------------------------------------------------
import os,sys,getopt,re,string

#===================================================================================================
# Main starts here
#===================================================================================================
# Define string to explain usage of the script
usage  = "\nUsage: hosts.py  --help\n\n"

# Define the valid options which can be specified and check out the command line
valid = ['help']
try:
    opts, args = getopt.getopt(sys.argv[1:], "", valid)
except getopt.GetoptError, ex:
    print usage
    print str(ex)
    sys.exit(1)

# --------------------------------------------------------------------------------------------------
# Get all parameters for the production
# --------------------------------------------------------------------------------------------------
# Set defaults for each option

# Read new values from the command line
for opt, arg in opts:
    if opt == "--help":
        print usage
        sys.exit(0)

i = 0
while i < 256:
    cmd = "host 18.77.2.%d"%(i)
    ip = "18.77.2.%d"%(i)
    for line in os.popen(cmd).readlines():   # run command
        line    = line[:-1]                  # strip '\n'
        f = line.split(" ")
        status = os.system('ping -c 1 ' + ip + ' >& /dev/null')
        if status == 0:
            print ' --active-- 18.77.2.%03d %s'%(i,f[-1])
        else:
            print ' -inactive- 18.77.2.%03d %s'%(i,f[-1])

    
    #os.system(cmd)
    i += 1

sys.exit(0)
