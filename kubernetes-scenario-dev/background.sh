#!/bin/bash
host=$(hostname)

echo "Setting up ansible, please wait...."

if [ ${host} == "master" ]; then
    apt install -y ansible \
    && echo "[servers]" > /etc/ansible/hosts \
    && echo "host01 ansible_host=host01" >> /etc/ansible/hosts \
    && echo "node01 ansible_host=node01" >> /etc/ansible/hosts
fi

rm /etc/apt/sources.list.d/yarn.list*

echo "done" >> /opt/.backgroundfinished