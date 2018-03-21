#!/bin/bash
. /etc/environment
#assuming *-cloud-provider role already installed
. /var/cloud-helper/metadata-provider.sh
function prepend_domain_name() {
  #statements
  sed -i "/#supersede domain-name/asupersede domain-name \"us-west-1.compute.internal mu.aws.ariba.com aws.ariba.com\";" /etc/dhcp/dhclient.conf
  ifdown $NETWORK_INTERFACE
  ifup $NETWORK_INTERFACE
}

function update_dnsmasq() {
  priv_ip=$(get_instance_ip_address)
  echo "server=/mu.aws.ariba.com/$priv_ip#8600" >/etc/dnsmasq.d/consul
  echo "listen-address=127.0.0.1" >>/etc/dnsmasq.d/consul
  echo "listen-address=$priv_ip" >>/etc/dnsmasq.d/consul

  echo "server=/aws.ariba.com/10.169.48.29#53" >/etc/dnsmasq.d/priv_hosted_zone
  echo "listen-address=127.0.0.1" >>/etc/dnsmasq.d/priv_hosted_zone
  echo "listen-address=$priv_ip" >>/etc/dnsmasq.d/priv_hosted_zone
  service dnsmasq restart
}
