#!/bin/bash

export GOMAXPROCS=$(nproc)
# Get the public IP
export IP4_ADD=$(ip addr show dev ${NETWORK_INTERFACE} | grep "inet " | tail -1 | awk '{ print $2 }' | sed 's/\/.*$//')

consul-template -template "/var/vault/config/vault.hcl.template:/var/vault/config/vault.hcl" -once

exec /usr/local/bin/vault server -config=/var/vault/config/vault.hcl >/var/log/vault.log 2>&1
