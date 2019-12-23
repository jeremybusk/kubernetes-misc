#!/bin/bash
set -e

export NODE_1="10.1.2.51"
export NODE_2="10.1.2.52"
export NODE_3="10.1.2.53"
# export USER=busk
export ROOT_USER=root
export USER=root
export SSH_ID="id_ed25519"
# sed -i "s/^%sudo.*/%sudo   ALL=(ALL:ALL) NOPASSWD:ALL/g" /etc/sudoers

# Create ssh key pair for install
ssh-keygen -t ed25519 -f $SSH_ID -q -N ""
ssh-copy-id -i $SSH_ID k1.uvoo.io
ssh-copy-id -i $SSH_ID k2.uvoo.io
ssh-copy-id -i $SSH_ID k3.uvoo.io
ssh k3.uvoo.io whoami
# sudo pkill ssh-agent
eval `ssh-agent`
ssh-add ${SSH_ID}

id_pub_text=$(cat $SSH_ID.pub)
for i in {1..3}; do
    ipaddr="10.1.2.5${i}"
    # ssh -i $SSH_ID $ipaddr "sudo mkdir -p /root/.ssh; sudo echo ${id_pub_text} | sudo tee -a /root/.ssh/authorized_keys"
    # ssh -i $SSH_ID root@$ipaddr "whoami"
    ssh $ipaddr "sudo mkdir -p /${USER}/.ssh; sudo echo ${id_pub_text} | sudo tee -a /${USER}/.ssh/authorized_keys"
    ssh $USER@$ipaddr "whoami"
done

# The first server starts the cluster
k3sup install \
  --ssh-key $SSH_ID \
  --cluster \
  --user $USER \
  --ip $NODE_1

# The second node joins
k3sup join \
  --ssh-key $SSH_ID \
  --server \
  --ip $NODE_2 \
  --user $USER \
  --server-user $USER \
  --server-ip $NODE_1

# The third node joins
k3sup join \
  --ssh-key $SSH_ID \
  --server \
  --ip $NODE_3 \
  --user $USER \
  --server-user $USER \
  --server-ip $NODE_1
