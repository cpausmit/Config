#!/usr/bin/env python
import json
import glob
import os
import time

def read_json(file):
    with open(file,'r') as f:
        data = json.load(f)
    return data

directory = "./logs"

# find all files
json_files = glob.glob(f"{directory}/*.json")

# sort the files based on their time stamps
sorted_files = sorted(json_files, key = os.path.getmtime)

#for f in os.listdir(directory):
#    if os.path.isfile(os.path.join(directory, f)):
for f in sorted_files:
    data = read_json(f"{f}")
    file_stats = os.stat(f)
    #for tag in data:
    #    print(tag)
    print(time.ctime(file_stats.st_mtime),file_stats.st_mtime,len(data))
    #print(data)
