#!/bin/bash

# Get the public IP
export IP4_ADD=$(ip addr show dev ${NETWORK_INTERFACE} | grep "inet " | tail -1 | awk '{ print $2 }' | sed 's/\/.*$//')

consul-template -template "/var/nomad/config/nomad.hcl.template:/var/nomad/config/nomad.hcl" -once

exec  nomad agent -config /var/nomad/config/nomad.hcl > /var/log/nomad.log 2>&1
