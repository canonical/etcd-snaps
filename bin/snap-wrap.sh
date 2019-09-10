#! /bin/bash

# Prepare ETCD environment variables

# Use the system writable dir if run as root
if [[ $EUID -ne 0 ]]; then
  DATA_DIR=$SNAP_USER_DATA
  CONF_DIR=$SNAP_USER_COMMON
  echo "Running as user with data in $DATA_DIR"
else
  DATA_DIR=$SNAP_DATA
  CONF_DIR=$SNAP_COMMON
  echo "Running as system with data in $DATA_DIR"
fi

# Check for a version 2.x config and bail if so
if [ -e $CONF_DIR/etcd.conf ]; then
  echo "etcd 3.4 is not compatible with 2.x."
  echo
  echo "It appears you have an existing etcd 2.x configuration in "
  echo "$CONF_DIR/etcd.conf. To upgrade from 2.x to 3.4, you must "
  echo "first upgrade to 3.0, then sequentially upgrade through "
  echo "3.1, 3.2, 3.3, and finally to 3.4."
  exit 1
fi

# See if there is a configuration file
TARGET_CONF=$CONF_DIR/etcd.conf.yml
if [ -e $TARGET_CONF ]; then
  echo "Configuration from $TARGET_CONF"
else
  echo "No config found, please create one at $TARGET_CONF"
  echo "See $SNAP/etcd.conf.yml.sample for an example."
  exit 0
fi

# Launch with the default config file
exec $SNAP/bin/etcd --config-file $TARGET_CONF "$@"

