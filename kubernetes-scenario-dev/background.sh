#!/bin/bash

echo "Setting up ansible, please wait...."

apt install -y ansible \
&& echo "[servers]" > /etc/ansible/hosts \
&& echo "" >> /etc/ansible/hosts \
&& echo "" >> /etc/ansible/hosts \
&& rm /etc/apt/sources.list.d/yarn.list*

echo "done" >> /opt/.backgroundfinished