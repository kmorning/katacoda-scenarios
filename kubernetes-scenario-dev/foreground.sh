#!/bin/bash
host=$(hostname)

# Remove package source since it causes a GPG key expired warning, and breaks ansible apt update
rm /etc/apt/sources.list.d/yarn.list*

# Only Wait on master
if [ ${host} == "master" ]; then
    echo "Installing ansible please wait...."
    while [ ! -f /opt/.backgroundfinished ] ; do sleep 2; done; echo "Done"
fi