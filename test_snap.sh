#!/bin/bash

set -eux

snapfile="$1"

snap remove etcd
snap install $snapfile --dangerous

# trick snap-wrap.sh into thinking we have conf
touch /var/snap/etcd/common/etcd.conf

# start etcd
systemctl start snap.etcd.etcd.service

# wait for server to start
sleep 2

curl -L http://127.0.0.1:2379/v2/keys/mykey -XPUT -d value="this is awesome"
curl -L http://127.0.0.1:2379/v2/keys/mykey

snap remove etcd
