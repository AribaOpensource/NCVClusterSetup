#!/bin/bash

export GOMAXPROCS=$(nproc)

# Get the public IP using metadata service
. /var/cloud-helper/metadata-provider.sh
export IP4_ADD=$(get_instance_ip_address)

consul-template -template "/var/vault/config/vault.hcl.template:/var/vault/config/vault.hcl" -once

exec /usr/local/bin/vault server -config=/var/vault/config/vault.hcl >/var/log/vault.log 2>&1
