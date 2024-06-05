#!/bin/bash

echo "sudo sshfs -o allow_other,default_permissions paus@ppc.mit.edu:/home /ppc"
sudo sshfs -o allow_other,default_permissions paus@ppc.mit.edu:/home /ppc

