#!/bin/bash

createPlaybook() {
    cat > /opt/kubernetes-setup.yaml <<"EOF"
- hosts: all
  become: true
  tasks:	  
  - name: Install Kubernetes binaries
    apt: 
      name: "{{ packages }}"
      state: present
      update_cache: yes
    vars:
      packages:
        - kubelet=1.17.5-00
        - kubeadm=1.17.5-00
        - kubectl=1.17.5-00
  - name: Initialize the Kubernetes cluster using kubeadm on {{inventory_hostname}}
    when: inventory_hostname == "host01"
    command: kubeadm init --service-cidr "172.29.0.0/16" --service-dns-domain "k8s.example.local"
  - name: Setup kubectl on {{inventory_hostname}}
    when: inventory_hostname == "host01"
    command: "{{ item }}"
    with_items:
     - mkdir -p /root/.kube
     - cp -i /etc/kubernetes/admin.conf /root/.kube/config
     - chown root:root /root/.kube/config
  - name: Install weave pod network
    become: false
    when: inventory_hostname == "host01"
    shell: curl -SL "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=172.28.0.0/16&env.NO_MASQ_LOCAL=1" | kubectl apply -f -
  - name: Generate join command on {{inventory_hostname}}
    command: kubeadm token create --print-join-command
    when: inventory_hostname == "host01"
    register: join_command
  - name: Copy join command to local server
    when: inventory_hostname == "host01"
    local_action: copy content="{{ join_command.stdout_lines[0] }}" dest="/tmp/join-command" mode=0700
  - name: Copy the file from master to node01
    copy: src=/tmp/join-command dest=/tmp/
    when: inventory_hostname == "node01"
  - name: Join the node01 to cluster
    when: inventory_hostname == "node01"
    command: sh /tmp/join-command
EOF
}

apt install -y ansible \
&& echo "[servers]" > /etc/ansible/hosts \
&& echo "host01 ansible_host=host01" >> /etc/ansible/hosts \
&& echo "node01 ansible_host=node01" >> /etc/ansible/hosts \
&& sed -i '/^\[defaults\]*/a host_key_checking = False' /etc/ansible/ansible.cfg
createPlaybook
echo "done" >> /opt/.backgroundfinished