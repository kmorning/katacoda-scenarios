## ZFS Setup
We could use simply a normal folder on the local filesystem for a Kubernetes persistent volume, but instead we'll be using ZFS volume.  One of the benefits ZFS provides is automatic filesystem compression, which we'll enable in this scenarion.  We can also use thin provisioning, which we'll cover in a later scenario.

## Install ZFS

Excute the following command on both master and worker to install the ZFS package:

`sudo apt install zfsutils-linux`{{execute HOST1}}

`sudo apt install zfsutils-linux`{{execute HOST2}}

## Create a ZFS Pool
Ideally, a ZFS pool would consist of one or more physical drives, with the data striped or mirrored across them.  As space requirement grow, more physical drives can be added.  Though less than ideal in a production environment, ZFS can be created from an empty partition, which is what we'll do given the limited resources in the current environment.

An empty partition has already been created on both the master and worker nodes.  Create a ZFS pool, called zfspool0, on both the master and worker nodes:

`zpool create zfspool0 /dev/vda2`{{execute HOST1}}

`zpool create zfspool0 /dev/vda2`{{execute HOST2}}

You list and view the status of the newly create pool with:

`zpool list`{{execute HOST1}}

`zpool status`{{execute HOST1}}

