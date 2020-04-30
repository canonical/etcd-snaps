#!/bin/bash

set -eux

snapfile="$1"

snap remove etcd
snap install $snapfile --dangerous

cp /snap/etcd/x1/etcd.conf.yml.sample /var/snap/etcd/common/etcd.conf.yml
systemctl start snap.etcd.etcd.service

/snap/bin/etcd.etcdctl --endpoints=localhost:2379 put foo bar
/snap/bin/etcd.etcdctl --endpoints=localhost:2379 get foo

version=$(grep version: snap/snapcraft.yaml | cut -d' ' -f2 | tr -d "'")

/snap/etcd/current/bin/etcdctl version | grep $version
/snap/etcd/current/bin/etcd --version | grep $version

snap remove etcd
