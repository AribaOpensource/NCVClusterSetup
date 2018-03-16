#!/bin/bash -e

sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
cd /var/tmp
sudo ansible-playbook -i "localhost," -c local ansible/site.yml