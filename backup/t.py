#!/usr/bin/env python
import os
with open("/home/test/.no-backup","r") as file:
    data = file.read()

cmd="tar fzcv /tmp/t.tgz "
for line in data.split("\n"):
    dir = line
    if dir != "":
        print dir
        cmd += " --exclude=\"%s\""%(dir)
    
cmd += " /home/test"

print cmd
os.system(cmd)
