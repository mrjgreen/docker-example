#!/bin/bash
set -e

# Make sure we have all the latest updates when we launch this instance
apt-get update -q

# Install some useful tools
apt-get install -yq curl htop iotop iftop lsof nano jq sysstat zip unzip
