#!/bin/bash

set -eux

snapfile="$1"

arch=$(dpkg --print-architecture)
if [[ "$arch" != "amd64" ]]; then
    export ETCD_UNSUPPORTED_ARCH="$arch"
fi

snap remove etcd
snap install $snapfile --dangerous

cp /snap/etcd/x1/etcd.conf.yml.sample /var/snap/etcd/common/etcd.conf.yml
systemctl start snap.etcd.etcd.service

/snap/bin/etcd.etcdctl --endpoints=localhost:2379 put foo bar
/snap/bin/etcd.etcdctl --endpoints=localhost:2379 get foo

version=$(grep source-tag: snap/snapcraft.yaml | sed 's/.*: v//')

/snap/etcd/current/bin/etcdctl version | grep $version
/snap/etcd/current/bin/etcd --version | grep $version
echo $snapfile | grep $version

snap remove etcd
