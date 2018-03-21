#!/bin/bash

. /etc/environment

# Get the public IP using metadata service
. /var/cloud-helper/metadata-provider.sh
export IP4_ADD=$(get_instance_ip_address)

consul-template -template "/var/nomad/config/nomad.hcl.template:/var/nomad/config/nomad.hcl" -once

exec nomad agent -config /var/nomad/config/nomad.hcl >/var/log/nomad.log 2>&1
