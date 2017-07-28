#!/bin/bash

set -e
# root
coreos-install -d /dev/sda -C stable -i /home/core/ignition
