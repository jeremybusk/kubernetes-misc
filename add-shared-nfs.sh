#!/bin/bash
set -e

sudo apt install nfs-common
sudo mkdir -p /data/nfs
sudo chmod 0777 /data/nfs
echo "nas1.example.com:/slow/kub-c1       /data/nfs      nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" > /etc/fstab
# # nas1.example.com:/home /data/nfs nfs rw,hard,intr,rsize=8192,wsize=8192,timeo=14 0 0
# /slow/kub-c1 10.x.x.0/255.255.255.0(rw)
