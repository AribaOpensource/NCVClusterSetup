#!/bin/bash

. /etc/environment
. /var/cobalt/systemd_scripts/dnsmasq-helper.sh

# Make sure to use all our CPUs, because Consul can block a scheduler thread
export GOMAXPROCS=$(nproc)

# Get the prvate  IP
export IP4_ADD=$(get_instance_ip_address)
export MACHINENAME=$(get_host_name)

echo $MACHINENAME >/etc/hostname

$(prepend_domain_name)
$(update_dnsmasq)
#restart dnsmasq so that it picks updated values
service dnsmasq restart

consul-template -template "/var/consul/config/consul.json.template:/tmp/consul/config/consul.json" -once
consul-template -template "/var/consul/config/encrypt.json.template:/tmp/consul/config/encrypt.json" -once
if [ "$IS_SERVER" = "true" ]; then
  STARTUP_PARAMS="-bootstrap-expect=${SERVER_COUNT} -server=true"
else
  STARTUP_PARAMS="-server=false"
fi

exec consul agent ${STARTUP_PARAMS} -config-dir=/tmp/consul/config >>/var/log/consul.log 2>&1
