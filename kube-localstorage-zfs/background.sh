#!/bin/bash

createPlaybook {
  cat > /tmp/scenario-setup.yaml <<"EOF"
- hosts: all
  become: true
  tasks:
  - name: Remove /dev/vda5
    parted:
      device: /dev/vda
      number: 5
      state: absent

  - name: Remove /dev/vda2
    parted:
      device: /dev/vda
      number: 2
      state: absent

  - name: Create a new primary /dev/vda2
    parted:
      device: /dev/vda
      number: 2
      state: present
EOF
}

createPlaybook
