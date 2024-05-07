#!/usr/bin/env python
import json
import glob,os,sys,subprocess
import time
import datetime
import matplotlib.pyplot as plt
import matplotlib as mlp
import numpy as np

NOW = datetime.datetime.now().strftime("%m/%d/%y, %H:%M")
NCALLS = "0 - 0"
#log_dir = '/home/submit/paus/logs/a2rchi'
log_dir = '/home/paus/logs/a2rchi'
#public_html = '/home/submit/paus/public_html/a2rchi'
public_html = '/home/paus/a2rchi'

server = "a2rchi.mit.edu"
server = "submit06.mit.edu"
file_path = "/root/data/conversations_test.json"
process_name = "prod-801-data-manager-prod-801"

def find_docker_id(server,process_name):
    cmd = f"ssh {server} docker ps|grep {process_name}|cut -d ' ' -f1"
    process = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    tags = stdout.decode().split("\n")
    tag = tags[0]
    return tag

def find_date_epoch():
    return time.time()

def get_latest_conversations(server,tag,file_path,log_dir):
    cmd = f"ssh {server} docker cp {tag}:{file_path} ."
    os.system(cmd)
    epoch = find_date_epoch()
    file_name = "conversations_test.json"
    cmd = f"scp {server}:{file_name} {log_dir}/conversations-{epoch}.json"
    os.system(cmd)
    cmd = f"ssh {server} rm {file_name}"
    os.system(cmd)

def plot(ad,d,nhours):
    min = ad.min()
    max = ad.max()
    nbins = int((max-min)/3600/nhours)

    # size of the pic
    fig = plt.gcf()
    fig.set_size_inches(10,7)
    
    # make hist for all messages per hour
    dtad = [datetime.datetime.fromtimestamp(p) for p in ad]
    plt.hist(dtad,bins=nbins,color='green',label=f'Messages ({len(ad)})')
    dtd = [datetime.datetime.fromtimestamp(p) for p in d]
    plt.hist(dtd ,bins=nbins,color='red',label=f'Conversations ({len(d)})')
    plt.legend(loc='upper left')
    ##plt.xticks(ordered_hour_bin_midpoints, ordered_hour_bin_labels)
    plt.xlabel(f'Time / {nhours} hours')
    plt.ylabel('A2rchi Interactions')
    ##plt.title('A2rchi activities over time / hour', fontsize=14)
    plt.xticks(rotation=45, ha='right')
    plt.gca().xaxis.set_major_formatter(mlp.dates.DateFormatter('%m/%d %H:%M'))
    plt.rcParams.update({'font.size': 18})
    ##plt.tick_params(axis='both', labelsize=8)
    
    # make sure to not have too much white space around the plot
    plt.subplots_adjust(top=0.99, right=0.99, bottom=0.24, left=0.10)

    ax = plt.gca()
    ax.annotate(NOW+' '+NCALLS,xy=(-0.10,0),
                xycoords=('axes fraction','figure fraction'),
                size=10, ha='left', va='bottom')
    plt.savefig(f"{public_html}/messages_per_{nhours}_hour.png")
    #plt.show()
    plt.clf()

os.makedirs(f"{log_dir}/",exist_ok=True)
tag = find_docker_id(server,process_name)
get_latest_conversations(server,tag,file_path,log_dir)

# find all files
json_files = glob.glob(f"{log_dir}/*.json")

# sort the files based on their time stamps
sorted_files = sorted(json_files, key = os.path.getmtime)
f = sorted_files[-1]
#for f in sorted_files:
#    #data = read_json(f"{f}")
#    #file_stats = os.stat(f)
#    #print(time.ctime(file_stats.st_mtime),file_stats.st_mtime,len(data))
#    pass

with open(f,"r") as file:
    convos = json.load(file)

dates = []
all_dates = []
min =  99999999
max = -99999999

# get dates for initialization date, all_dates for any message date
for key in convos:
    time_stamp_i = float(convos[key]['meta']['time_first_used'])
    time_stamp_f = float(convos[key]['meta']['time_last_used'])
    dates.append(time_stamp_i)

    # ALL dates
    if 'times_chain_was_called' in convos[key]['meta'].keys():
        time_stamps = convos[key]['meta']['times_chain_was_called']
        for time_stamp in time_stamps:
            #print(" Adding more times")
            all_dates.append(float(time_stamp))

# go numpy
d = np.array(dates)
ad = np.array(all_dates)
print(len(dates),len(all_dates))
NCALLS = f" N: {len(dates)} --> {len(all_dates)}"

plot(ad,d,24)
plot(ad,d,24)
plot(ad,d, 8)
plot(ad,d, 4)
plot(ad,d, 1)
