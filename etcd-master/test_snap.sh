#!/bin/bash

set -eux

snapfile="$1"

snap remove etcd
snap install $snapfile --dangerous
snap list
snap aliases etcd

cp /snap/etcd/x1/etcd.conf.yml.sample /var/snap/etcd/common/etcd.conf.yml
systemctl start snap.etcd.etcd.service
hash -r

ETCDCTL_API=3 /snap/bin/etcd.etcdctl --endpoints=localhost:2379 put foo bar
ETCDCTL_API=3 /snap/bin/etcd.etcdctl --endpoints=localhost:2379 get foo

snap remove etcd
