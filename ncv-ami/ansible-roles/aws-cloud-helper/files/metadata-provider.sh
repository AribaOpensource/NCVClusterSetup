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
