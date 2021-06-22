#!/usr/bin/python
#====================================================================================================
#
# Make defined snippets of a given video input file (mp4 format).
#
# Requirements:
# - install ffmpeg
#
# Video session 1:
#
## Fisher:
#   cut-video.py --input 3184_Year_of_the_Quark_01.mp4 --output fisher.mp4 \
#                --start "00:00:00" --end "00:04:50"
## Zweig:
#   cut-video.py --input 3184_Year_of_the_Quark_01.mp4 --output zweig.mp4 \
#                --start "00:04:51" --end "00:35:51"
## LLewellyn-Smith:
#   cut-video.py --input 3184_Year_of_the_Quark_01.mp4 --output llewellyn-smith.mp4 \
#                --start "00:35:54" --end "01:16:00"
## Breidenbach:
#   cut-video.py --input 3184_Year_of_the_Quark_01.mp4 --output breidenbach.mp4 \
#                --start "01:16:00" --end "01:44:34"
#
# Video session 2:
#
## Bodek:
#   cut-video.py --input 3184_Year_of_the_Quark_02.mp4 --output bodek.mp4 \
#                --start "00:00:00" --end "00:23:11"
## Riordan:
#   cut-video.py --input 3184_Year_of_the_Quark_02.mp4 --output riordan.mp4 \
#                --start "00:23:13" --end "00:55:01"
## Jaffe:
#   cut-video.py --input 3184_Year_of_the_Quark_02.mp4 --output jaffe.mp4 \
#                --start "00:55:00" --end "01:33:22"
#
#                                                                         Ch. Paus (V0, Nov 07, 2019)
#====================================================================================================
import os,sys,getopt

#====================================================================================================
# H E L P E R S 
#====================================================================================================

#===================================================================================================
# M A I N
#===================================================================================================
# Command line options and their defaults
input = "i.mp4"    # input file
output = "o.mp4"   # output file
start = "00:00:00" # at the beginning
end = "00:05:00"   # at five minutes into the file

# Define string to explain usage of the script
usage  = "\nUsage: cut-video.py --input=i.mp4 --output=o.mp4 --start=00:00:00 --end=00:05:00 \n"

valid = ['input=','output=','start=','end=','debug','help']
try:
    opts, args = getopt.getopt(sys.argv[1:], "", valid)
except getopt.GetoptError, ex:
    print usage
    print str(ex)
    sys.exit(1)

# read all command line options
for opt, arg in opts:
    if opt == "--help":
        print usage
        sys.exit(0)
    if opt == "--input":
        input = arg
    if opt == "--output":
        output = arg
    if opt == "--start":
        start = arg
    if opt == "--end":
        end = arg
cmd = "ffmpeg -ss %s -i %s -to %s -c:v libx264 -c:a copy %s"%(start,input,end,output)        
print " CMD: %s"%(cmd)
os.system(cmd)

# and exit!
sys.exit(0)
