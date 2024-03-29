


# A security group that makes the instances accessible
resource "aws_security_group" "consul" {
  name_prefix = "${var.clustername}"
  vpc_id      = "${var.vpc_id}"

  #SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  from_port   = "53"
  to_port     = "53"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  from_port   = "53"
  to_port     = "53"
  protocol    = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  }

  #HTTP Access
    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    #Nomad Access
    ingress {
      from_port   = 4646
      to_port     = 4646
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    #Nomad Access
    ingress {
      from_port   = 4647
      to_port     = 4647
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    #Nomad Access
    ingress {
      from_port   = 4648
      to_port     = 4648
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    #Nomad Access
    ingress {
      from_port   = 4648
      to_port     = 4648
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }


    #vault Access
    ingress {
      from_port   = 8200
      to_port     = 8200
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    # vault Cluster Listener Addresses
    ingress {
      from_port   = 8201
      to_port     = 8201
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    #consul_allow_server_rpc_inbound
    ingress {
    from_port   = "8300"
    to_port     = "8300"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }



#consul_allow_cli_rpc_inbound
    ingress {
    from_port   = "8400"
    to_port     = "8400"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

#consul_allow_serf_lan_tcp_inbound
      ingress {
    from_port   = "8301"
    to_port     = "8301"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

#consul_allow_serf_lan_udp_inbound
   ingress {
    from_port   = "8301"
    to_port     = "8301"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    }

#consul_allow_serf_wan_tcp_inbound
    ingress {
    from_port   = "8302"
    to_port     = "8302"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

#consul_allow_serf_wan_udp_inbound
    ingress {
    from_port   = "8302"
    to_port     = "8302"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    #Consul Access/allow_http_api_inbound
    ingress {
      from_port   = 8500
      to_port     = 8500
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }


    #consul_allow_dns_tcp_inbound
        ingress {
        from_port   = "8600"
        to_port     = "8600"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }

    #consul_allow_dns_udp_inbound
        ingress {
        from_port   = "8600"
        to_port     = "8600"
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
        }




#allow all outboud connections
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }









}


# Create an IAM role for the auto-join
resource "aws_iam_role" "consul-join" {
  name               = "${var.clustername}-consul-join"
  assume_role_policy = "${file("${path.module}/templates/policies/assume-role.json")}"
}


# Attach the policy and use existing policy
resource "aws_iam_role_policy_attachment" "consul-join" {
    role       = "${aws_iam_role.consul-join.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# Create the instance profile
resource "aws_iam_instance_profile" "consul-join" {
  name  = "${var.clustername}-consul-join"
  role = "${aws_iam_role.consul-join.name}"
}
