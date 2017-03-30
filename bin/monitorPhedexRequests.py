#!/usr/bin/env python

with open("/home/cmsprod/.phedexrequests","r") as f:
    data = f.read()
    requests = data.split("\n")

for request in requests:
    print " Id: %s" + request
