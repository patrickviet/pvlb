#!/bin/bash -e

if [ "$UID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Only run it if we can (ie. not on RH)
if [ -x /usr/bin/apt-get ]; then
  apt-get update
fi

# Only install chef if it's not there yet
if [ ! -x /usr/bin/chef-solo ]
then
  curl -L https://www.opscode.com/chef/install.sh | bash
fi

mkdir -p /etc/chef
rsync -avP ./ /etc/chef/src/
cp solo.rb /etc/chef/solo.rb

chef-solo -o pvlb

