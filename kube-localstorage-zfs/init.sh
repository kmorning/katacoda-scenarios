#!/bin/bash

HOST=$(hostname)

show_progress()
{
  echo -n "Please wait while the disks are setup..."
  local -r pid="${1}"
  local -r delay='0.75'
  local spinstr='\|/-'
  local temp
  while true; do
    if [ ! -f /tmp/.initdone ] ; then
      temp="${spinstr#?}"
      printf " [%c]  " "${spinstr}"
      spinstr=${temp}${spinstr%"${temp}"}
      sleep "${delay}"
      printf "\b\b\b\b\b\b"
    else
      break
    fi
  done
  printf "    \b\b\b\b"
  echo ""
  echo "Done"
}

installAnsible() {
  add-apt-repository -y ppa:ansible/ansible-2.3 \
  && apt update \
  && apt install -y ansible \
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

  echo "Configuring disks, please wait..."
  while [ ! -f /tmp/scenario-setup.yaml ] ; do sleep 2; done
  ansible-playbook /tmp/scenario-setup.yaml

  echo "Cleaning up..."
  #rm /tmp/* -fr

  echo "Disk configuration complete!"
else
  reset
  show_progress
fi