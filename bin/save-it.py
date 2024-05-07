#!/bin/env python
import os,sys,glob,datetime
from optparse import OptionParser

def find_secret(directory,file_name):
    with open(f"{directory}/{file_name}",'r') as f:
        secret = f.read()
    return secret.strip().split(":")

parser = OptionParser()
# defining the key parameters
parser.add_option("-o", "--host",dest="host",default='localhost',help="host the DB is on")
parser.add_option("-s", "--secr",dest="secr",default='.ppc_web',help="password to access database")
parser.add_option("-n", "--name",dest="name",default='ppc_web',help="name of the database to be saved")
parser.add_option("-i", "--dir",dest="dir",default='/var/www/html',help="name of the web server directory")
parser.add_option("-t", "--target",dest="target",default='/backup/ppc_web',help="backup directory")
# steering the process
parser.add_option("-d", "--debug",dest="debug",default=0,help="debugging level")
parser.add_option("-e", "--execute",action="store_true",dest="execute",default=False,help="execute merge")
(options, args) = parser.parse_args()

user, pwrd = find_secret(options.target,options.secr)
current_datetime = datetime.datetime.now()
date = current_datetime.strftime("%y%m%d_%H%M%S")
pwd = os.getcwd()
backup_sql = f"{options.name}-backup-{date}.sql"
backup_tar = f"{pwd}/{options.name}-backup-{date}.tar"
basename = options.dir.split('/')[-1]

# backup the mysql database
cmd = f"mysqldump -h {options.host} -u {user} -p{pwrd} {options.name} > {backup_sql}"
rc = os.system(cmd)
if rc == 0:
    print(f" sql backup succeeded.")
    rc = os.system(f"ls -lhrt {backup_sql} ")
else:
    print(f" sql backup failed {rc}.")

# backup the html base directory
cmd = f"cd {options.dir}/..; tar fc {backup_tar} {basename}"
rc = os.system(cmd)
if rc == 0:
    print(f" directory backup succeeded.")
    rc = os.system(f"ls -lhrt {backup_tar} ")
else:
    print(f" directory backup failed {rc}.")

# compactify
cmd = f"tar rf {backup_tar} {backup_sql}; rm {backup_sql};"
rc = os.system(cmd)
if rc == 0:
    print(f" backup compactification succeeded.")
    rc = os.system(f"ls -lhrt {backup_tar};# tar ft {backup_tar}")
else:
    print(f" backup compactification failed {rc}.")

# move to final place
cmd = f"mv {backup_tar} {options.target}/;"
rc = os.system(cmd)
if rc == 0:
    print(f" backup storage succeeded.")
    rc = os.system(f"ls -lhrt {options.target}/")
else:
    print(f" backup storage failed {rc}.")

# clear out older versions
# TO BE IMPLEMENTED
