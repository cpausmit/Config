#!/usr/bin/env python3
#
import os,sys,glob
from optparse import OptionParser

DEBUG = 0

parser = OptionParser()
parser.add_option("-s", "--source",dest="source",default='src',help="source directory")
parser.add_option("-t", "--target",dest="target",default='tgt',help="target directory")
parser.add_option("-e", "--execute",action="store_true",dest="execute",default=False,help="execute merge")
(options, args) = parser.parse_args()

def sizes(dir = ""):

    # Get a list of files (file paths) in the given directory 
    list_of_files = filter(os.path.isfile,glob.glob(dir + '/**/*', recursive=True))

    # get list of ffiles with size
    files_with_sizes = {}
    for file_path in list_of_files:
        key = file_path.replace(dir,'')
        files_with_sizes[key] = os.stat(file_path).st_size

    return files_with_sizes

# and print them one by one
print(os.getcwd())

source_files = {}
if os.path.exists(options.source):
    os.chdir(options.source)
    source_files = sizes(os.getcwd())
else:
    print(" ERROR - Source does not exist. EXIT!")
    sys.exit(1)

# exit if it is empty
if len(source_files)<1:
    print(source_files)
    sys.exit(0)

target_files = {}
if os.path.exists(options.target):
    os.chdir(options.target)
    target_files = sizes(os.getcwd())

if DEBUG>0:
    print(source_files)

os.chdir(options.source)
for key in source_files:

    file_path = "%s/%s"%(options.source,key)

    new_path = file_path.replace(options.source,options.target)
    new_dir = "/".join(new_path.split("/")[:-1])

    if os.path.exists(new_dir):
        if DEBUG>0:
            print(" new directory exists: %s"%(new_dir))
    else:
        cmd = "mkdir -p %s"%(new_dir)
        if DEBUG>0:
            print(" Mkdir: %s"%(cmd))
        if (options.execute):
            os.system(cmd)
 
    if key in target_files:
        print(" File exists alread: %s"%(new_path))
        if target_files[key] != source_files[key]:
            print(" ERROR - inconsistent file discovered: %d - %d"%(source_files[key],target_files[key]))
            #sys.exit(0)
    else:
        cmd = "mv %s %s"%(file_path,new_path)
        if DEBUG>0:
            print(" Move: %s"%(cmd))
        if (options.execute):
            os.system(cmd)
