#!/usr/bin/env python
#===================================================================================================
# Take a given directory, scan for photos and movies and move them to my local album, splitting
# per year and sub-splitting per month.
#
#---------------------------------------------------------------------------------------------------
#                                                                         Oct 01, 2011 (v0, Ch.Paus)
#===================================================================================================
import sys,os,re,getopt
from PIL import Image
from PIL.ExifTags import TAGS

def getCameraModelName(data,model):
    if model != '':
        print " Model name has been fixed to: " + model
    else:
        try:
            model = data['CameraModelName']
        except:
            try:
                model = data['Make']
            except:
                print " ERROR - no model name found."
                sys.exit(1)

    return model

def getDateTime(data):

    dateTime = ''
    try:
        dateTime = data['DateTimeOriginal']
    except:
        dateTime = ''

    if dateTime == '':
        try:
            dateTime = data['FileModificationDateTime']
        except:
            dateTime = ''

    if dateTime == '':
        try:
            dateTime = data['DateTimeDigitized']
        except:
            dateTime = ''
    
    if dateTime == '':
        x = 3/0

    return dateTime

def getChecksum(fn):
    checksum = ''
    cmd = 'md5sum "' + fn + '" | cut -d " " -f 1'
    for line in os.popen(cmd).readlines():
        checksum = line[:-1]
    return checksum

def getExif(fn,debug=False):
    cmd = 'exiftool \"' + fn + '"'
    ret = {}
    for line in os.popen(cmd).readlines():
        line = line[:-1]
        f = line.split(': ')
        key   = f[0]
        key   = key.replace(' ','')
        key   = key.replace('/','')
        value = f[1]
        if debug:
            print key + ' ' + value
        ret[key] = value
    return ret

def getVideoExif(fn):
    cmd = 'exiftool \"' + fn + '"'
    ret = {}
    for line in os.popen(cmd).readlines():
        line = line[:-1]
        f = line.split(': ')
        key   = f[0]
        key   = key.replace(' ','')
        key   = key.replace('/','')
        value = f[1]
        ret[key] = value
    return ret

def newPhotoData(cksum,data,model,debug):
    dateTime = getDateTime(data)
    model    = getCameraModelName(data,model)
    
    f        = dateTime.split(' ')
    if debug>0:
        print " Array length: %d"%(len(f))
        print f
        if len(f)<2:
            f = dateTime.split('-')
    print ""
    date     = f[0]
    time     = f[1]
    dateTime = dateTime.replace(' ','-')
    model    = model.replace(' ','-')
    fileName = dateTime + '_' + model + '_' + cksum + '.jpg'

    f        = date.split(':')
    if debug>0:
        print " Array length: %d"%(len(f))
        print f
        if len(f)<2:
            f = dateTime.split('-')
    photoData = {}
    photoData['FileName'] = fileName
    photoData['Year']     = f[0]
    photoData['Month']    = f[1]
    photoData['Day']      = f[2]
    photoData['Time']     = time

    return photoData

def newVideoData(cksum,data,model,debug):
    dateTime = getDateTime(data)
    model    = getCameraModelName(data,model)

    f        = dateTime.split(' ')
    date     = f[0]
    time     = f[1]
    dateTime = dateTime.replace(' ','-')
    model    = model.replace(' ','-')
    if   "avi" in data['FileName'].lower():
        fileName = dateTime + '_' + model + '_' + cksum + '.avi'
    elif "mov" in data['FileName'].lower():
        fileName = dateTime + '_' + model + '_' + cksum + '.mov'
    elif "mp4" in data['FileName'].lower():
        fileName = dateTime + '_' + model + '_' + cksum + '.mp4'
    else:
        fileName = dateTime + '_' + model + '_' + cksum + '.3gp'
    f        = date.split(':')

    videoData = {}
    videoData['FileName'] = fileName
    videoData['Year']     = f[0]
    videoData['Month']    = f[1]
    videoData['Day']      = f[2]
    videoData['Time']     = time

    return videoData

def makePhotoFileList(path,debug):
    cmd = 'find \"' + path + '\" \( -iname %s\*.jpg -o -iname %s\*.jpeg \)'%(pattern,pattern)
    if debug:
        print ' Search: ' + cmd
    photoFileList = []
    for photoFile in os.popen(cmd).readlines():
        photoFile = photoFile[:-1]
        if debug:
            print ' Photo: ' + photoFile
        photoFileList.append(photoFile)
    return photoFileList

def makeVideoFileList(path,debug):
    cmd = 'find \"' + path + \
          '\" \( -iname %s\*.3gp -o -iname %s\*.mov -o -iname %s\*.mp4 -o -iname %s\*.avi \)' \
          %(pattern,pattern,pattern,pattern)
    if debug:
        print ' Search: ' + cmd
    videoFileList = []
    for videoFile in os.popen(cmd).readlines():
        videoFile = videoFile[:-1]
        if debug:
            print ' Video: ' + videoFile
        videoFileList.append(videoFile)
    return videoFileList

def execute(cmd,debug,test):
    rc = 0

    if not test:
        if debug:
            print ' Executing: ' + cmd            
        rc = os.system(cmd)
    else:
        print ' Testing: ' + cmd

    return rc


#===================================================================================================
# Main
#===================================================================================================
# Define string to explain usage of the script
usage  = "\nUsage: orderPhotos.py  --help --album= --path= [ --model=]\n\n"

# Define the valid options which can be specified and check out the command line
valid = ['help','debug','test','path=','pattern=','album=','model=']
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
debug = False
test  = False
album = '/export/photos/cpAlbum'
path  = '/home/paus/Pictures'
pattern = ''
model = ''

# Read new values from the command line
for opt, arg in opts:
    if opt == "--help":
        print usage
        sys.exit(0)
    if opt == "--debug":
        debug = True
    if opt == "--test":
        test  = True
    if opt == "--album":
        album = arg
    if opt == "--path":
        path  = arg
    if opt == "--pattern":
        pattern  = arg
    if opt == "--model":
        model = arg

# Make list of photos and move and rename
photoFileList = makePhotoFileList(path,debug)
for photoFile in photoFileList:
    if debug:
        print photoFile
    cksum     = getChecksum(photoFile)
    data      = getExif(photoFile,debug)
    photoData = newPhotoData(cksum,data,model,debug)
    if debug:
        print ' Time of picture------: ' + photoData['Time']
        print ' Year-----------------: ' + photoData['Year']
        print ' Month----------------: ' + photoData['Month']
        print ' Day------------------: ' + photoData['Day']
        print ' Standardized filename: ' + photoData['FileName']
    dir = photoData['Year'] + '/' + photoData['Month']
    cmd = 'mkdir -p ' + album + '/' + dir
    execute(cmd,debug,test)

    source = photoFile
    target = album + '/' + dir + '/' + photoData['FileName']
    if os.path.isfile(target):
        print ' File (%s) exists already.... %s'%(source,target)

        # figure out whether they are the same
        cmd = 'md5sum "' + source + '" | cut -d " " -f 1'
        for line in os.popen(cmd).readlines():
            sourceCsm = line[:-1]
        cmd = 'md5sum "' + target + '" | cut -d " " -f 1'
        for line in os.popen(cmd).readlines():
            targetCsm = line[:-1]

        if sourceCsm != targetCsm:
            print " Different Files:  %s  <>  %s"%(sourceCsm,targetCsm)

        continue

    cmd = 'mv \"' + photoFile + '\" ' + album + '/' + dir + '/' + photoData['FileName']
    print ' Cmd: ' + cmd
    execute(cmd,debug,test)

    cmd = 'exiftool -Model=\"' + model + '\" -DateTimeOriginal=\"' + getDateTime(data) + \
        '\" ' + album + '/' + dir + '/' + photoData['FileName']
    print ' Cmd: ' + cmd
    rc = execute(cmd,debug,test)
    if rc == 0:
        execute('rm -f ' + album + '/' + dir + '/' + photoData['FileName'] + '_original',debug,test)

# Make list of videos (movies) and move and rename
videoFileList = makeVideoFileList(path,debug)
for videoFile in videoFileList:
    cksum     = getChecksum(videoFile)
    data      = getVideoExif(videoFile)
    if debug:
        print data
    videoData = newVideoData(cksum,data,model,debug)
    if debug:
        print ' Time of movie--------: ' + videoData['Time']
        print ' Year-----------------: ' + videoData['Year']
        print ' Month----------------: ' + videoData['Month']
        print ' Day------------------: ' + videoData['Day']
        print ' Standardized filename: ' + videoData['FileName']
    dir = videoData['Year'] + '/' + videoData['Month']
    cmd = 'mkdir -p ' + album + '/' + dir
    execute(cmd,debug,test)
    cmd = 'mv \"' + videoFile + '\" ' + album + '/' + dir + '/' + videoData['FileName']
    print ' Cmd: ' + cmd
    execute(cmd,debug,test)

    cmd = 'exiftool -Model=\"' + model + '\" -DateTimeOriginal=\"' + getDateTime(data) + \
        '\" ' + album + '/' + dir + '/' + videoData['FileName']
    print ' Cmd: ' + cmd
    rc = execute(cmd,debug,test)
    if rc == 0:
        print ' Execution worked with code: ' + str(rc)
    #    execute('rm -f ' + album + '/' + dir + '/' + photoData['FileName'] + '_original',debug,test)
    else:
        print ' Execution failed with code: ' + str(rc)

# Try to remove the directory if empty
cmd = 'rmdir \"' + path + '\" >& /dev/null'
execute(cmd,debug,test)

sys.exit(0)
