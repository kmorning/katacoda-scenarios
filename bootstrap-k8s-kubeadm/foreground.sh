#!/bin/bash

# Remove package source since it causes a GPG key expired warning, and breaks ansible apt update
rm /etc/apt/sources.list.d/yarn.list*
