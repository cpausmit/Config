#!/usr/bin/env python
import subprocess
import time
import os

interval = 3600
server = "a2rchi.mit.edu"
file_path = "/root/data/conversations_test.json"
process_name = "prod-801-data-manager-prod-801"
tmp_dir = "/tmp/paus/logs"

def find_docker_id(server,process_name):
    cmd = f"ssh {server} docker ps|grep {process_name}|cut -d ' ' -f1"
    process = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    tags = stdout.decode().split("\n")
    tag = tags[0]
    return tag

def find_date_epoch():
    return time.time()

def get_latest_conversations(server,tag,file_path,tmp_dir):
    cmd = f"ssh {server} docker cp {tag}:{file_path} ."
    os.system(cmd)
    epoch = find_date_epoch()
    file_name = "conversations_test.json"
    cmd = f"scp {server}:{file_name} {tmp_dir}/conversations-{epoch}.json"
    os.system(cmd)
    cmd = f"ssh {server} rm {file_name}"
    os.system(cmd)

os.makedirs(f"{tmp_dir}/",exist_ok=True)
    
while True:
    tag = find_docker_id(server,process_name)
    get_latest_conversations(server,tag,file_path,tmp_dir)
    print(f" Sleeping for {interval} seconds (now:{find_date_epoch()})")
    time.sleep(interval)
