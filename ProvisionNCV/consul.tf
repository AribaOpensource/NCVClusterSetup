
# Create the Consul cluster
resource "aws_instance" "server" {
  count = "${var.server_count}"

  ami           = "ami-f1e2f691"
  instance_type = "${var.instance_type}"
  key_name      = "awsuser"

  subnet_id              = "${var.subnet_id}"
  iam_instance_profile   = "${aws_iam_instance_profile.consul-join.name}"
  vpc_security_group_ids = ["${aws_security_group.consul.id}"]

    tags {
    Name = "${var.clustername}-server-${count.index}",
    clustername = "${var.clustername}"
  }

  connection {
    host = "${self.private_ip}"
    user = "${var.username}"
    private_key   = "${file("${var.private_key}")}"
    timeout = "2m"
  }

  root_block_device {
    volume_type = "standard"
    volume_size = "100"
    delete_on_termination = true
  }

#  provisioner "file" {
    #source        = "${path.module}/files"
    #destination   = "${var.tmp_files}"
  #}

  # Add to env settings
   provisioner "remote-exec" {
     inline = [
#       "sudo bash -c \"sudo chmod 755 `find ${var.tmp_files} -name '*.sh'`\"",
       "sudo bash -c \"sudo echo export IS_SERVER=true >> /etc/environment\"",
       "sudo bash -c \"sudo echo export PROVIDER_TYPE=${var.provider_type} >> /etc/environment\"",
       "sudo bash -c \"sudo echo export CLOUD_PROVIDER_KEY_NAME=${var.cloud_provider_key_name} >> /etc/environment\"",
       "sudo bash -c \"sudo echo export TAG_VALUE=${var.clustername} >> /etc/environment\"",
       "sudo bash -c \"sudo echo export DATACENTER=${var.datacenter} >> /etc/environment\"",
       "sudo bash -c \"sudo echo export MUDOMAIN=${var.mudomain} >> /etc/environment\"",
       "sudo bash -c \"sudo echo export RECURSORS=${var.recursors} >> /etc/environment\"",
       "sudo bash -c \"sudo echo export NETWORK_INTERFACE=${var.network_interface} >> /etc/environment\"",
       "sudo bash -c \"sudo echo export SERVER_COUNT=${var.server_count} >> /etc/environment\""

     ]
   }


}



output "servers" {
  value = ["${aws_instance.server.*.private_ip}"]
}
