#!/bin/bash

HOST=$(hostname)

installAnsible() {
  apt install -y ansible \
  && echo "[servers]" > /etc/ansible/hosts \
  && echo "host01 ansible_host=host01" >> /etc/ansible/hosts \
  && echo "node01 ansible_host=node01" >> /etc/ansible/hosts \
  && sed -i '/^\[defaults\]*/a host_key_checking = False' /etc/ansible/ansible.cfg
}

fixSources() {
  # Remove package source since it causes a GPG key expired warning, and breaks ansible apt update
  rm /etc/apt/sources.list.d/yarn.list*
}

echo "Fixing sources.list.d..."
fixSources

if [ ${HOST} == "master" ]; then
  echo "Installing Ansible..."
  installAnsible

  echo "Creating the Kubernetes cluster, this will take several minutes..."
  while [ ! -f /tmp/kubernetes-setup.yaml ] ; do sleep 2; done
  ansible-playbook /tmp/kubernetes-setup.yaml

  echo "Cleaning up..."
  #rm /tmp/* -fr

  echo "The Kubernetes cluster in now ready!"
else
  reset
  echo "Please wait while the Kubernetes cluster is created.  This could take several minutes..."
  while [ ! -f /tmp/.initdone ] ; do sleep 2; done; echo "Done"
  #rm /tmp/* -fr
fi

