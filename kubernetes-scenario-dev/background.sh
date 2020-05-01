#!/bin/bash

apt install -y ansible \
&& echo "[servers]" > /etc/ansible/hosts \
&& echo "host01 ansible_host=host01" >> /etc/ansible/hosts \
&& echo "node01 ansible_host=node01" >> /etc/ansible/hosts \
&& sed -i '/^\[defaults\]*/a host_key_checking = False' /etc/ansible/ansible.cfg
echo "done" >> /opt/.backgroundfinished
