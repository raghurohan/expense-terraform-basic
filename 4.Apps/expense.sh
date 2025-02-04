#!/bin/bash

sudo dnf install -y ansible
cd /tmp
git clone https://github.com/raghuatharva/expense-ansible.git

#there is some issue with this repo. the configuration is not working as expected.
cd expense-ansible
ansible-playbook -i inventory.ini mysql.yaml
ansible-playbook -i inventory.ini backend.yaml
ansible-playbook -i inventory.ini frontend.yaml

