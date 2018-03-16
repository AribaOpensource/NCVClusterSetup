#!/bin/bash
EC2_INSTANCE_METADATA_URL="http://169.254.169.254/latest/meta-data"
EC2_INSTANCE_DYNAMIC_DATA_URL="http://169.254.169.254/latest/dynamic"

function lookup_path_in_instance_metadata() {
  local readonly path="$1"
  curl --silent --show-error --location "$EC2_INSTANCE_METADATA_URL/$path/"
}

function lookup_path_in_instance_dynamic_data() {
  local readonly path="$1"
  curl --silent --show-error --location "$EC2_INSTANCE_DYNAMIC_DATA_URL/$path/"
}

function get_instance_ip_address() {
  lookup_path_in_instance_metadata "local-ipv4"
}

function get_host_name() {
  lookup_path_in_instance_metadata "hostname"
}

function get_instance_region() {
  lookup_path_in_instance_dynamic_data "instance-identity/document" | jq -r ".region"
}

function prepend_domain_name() {
  #statements
  sed -i "/#supersede domain-name/asupersede domain-name \"us-west-1.compute.internal mu.aws.ariba.com aws.ariba.com\";" /etc/dhcp/dhclient.conf
  ifdown ens3
  ifup ens3
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
