variable "aws_region" {
  description = "AWS region to create the environment"
}

variable "aws_access_key" {
  description = "AWS access key for account"
}

variable "aws_secret_key" {
  description = "AWS secret for account"
}

variable "instance_type" {
  default = "t2.micro"
}


variable server_count {}
variable username {}
variable private_key {}
variable "clients" {
  description = "The number of consul client instances"
}

variable "consul_version" {
  description = "The version of Consul to install (server and client)."
  default     = "1.0.6"
}

variable "vpc_id" {
  description = "VPC ID"
}


variable "subnet_id" {
  description = "subnet id"
}


variable clustername {}
variable provider_type{}
variable cloud_provider_key_name{}

variable datacenter{}
variable mudomain{}
variable recursors{}
variable network_interface{}

variable "server_rpc_port" {
  description = "The port used by servers to handle incoming requests from other agents."
  default     = 8300
}

variable "cli_rpc_port" {
  description = "The port used by all agents to handle RPC from the CLI."
  default     = 8400
}

variable "serf_lan_port" {
  description = "The port used to handle gossip in the LAN. Required by all agents."
  default     = 8301
}

variable "serf_wan_port" {
  description = "The port used by servers to gossip over the WAN to other servers."
  default     = 8302
}

variable "http_api_port" {
  description = "The port used by clients to talk to the HTTP API"
  default     = 8500
}

variable "dns_port" {
  description = "The port used to resolve DNS queries."
  default     = 8600
}
