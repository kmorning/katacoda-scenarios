## ZFS Setup
We could simply use a normal folder on the local filesystem for a Kubernetes persistent volume, but instead we'll be using ZFS volume.  One of the benefits ZFS provides is automatic filesystem compression, which we'll enable in this scenarion.  We can also use thin provisioning, which we'll cover in a later scenario.

## Install ZFS
First update the package list on both nodes:

<b>master:</b> `sudo apt update`{{execute HOST1}}

<b>node01:</b> `sudo apt update`{{execute HOST2}}

Excute the following command on both master and worker to install the ZFS package:

<b>master:</b> `sudo apt install zfsutils-linux`{{execute HOST1}}

<b>node01:</b> `sudo apt install zfsutils-linux`{{execute HOST2}}

## Create a ZFS Pool
Ideally, a ZFS pool would consist of one or more physical drives with the data striped or mirrored across them.  As space requirements grow, more physical drives can be added.  Though less than ideal in a production environment, ZFS can be created from an empty partition, which is what we'll do given the limited resources in the current environment.

An empty partition has already been created on both the master and worker nodes.  Create a ZFS pool, called zfspool0, on both the master and worker nodes:

<b>master:</b> `zpool create zfspool0 /dev/vda2`{{execute HOST1}}

<b>node01:</b> `zpool create zfspool0 /dev/vda2`{{execute HOST2}}

You can list and view the status of the newly create pool with:

<b>master:</b> `zpool list`{{execute HOST1}}

<b>master:</b> `zpool status`{{execute HOST1}}

<b>node01:</b> `zpool list`{{execute HOST2}}

<b>node01:</b> `zpool status`{{execute HOST2}}

## Create a ZFS

Now we'll create the ZFS volumes that will be used later for the local persistent volumes for our Kubernetes pods.  The volume on each node will be named vol1:

<b>master:</b> `zfs create zfspool0/vol0`{{execute HOST1}}

<b>node01:</b> `zfs create zfspool0/vol0`{{execute HOST2}}

The newly created volume can be seen with:

<b>master:</b> `zfs list`{{execute HOST1}}

<b>node01:</b> `zfs list`{{execute HOST2}}

You can see the volume has been mounted at /zfspool0/vol0

## Set Quota and Reservation

When you create a ZFS filesystem, by default it consumes all the space in the pool. So, you must specify a quota and reservation for the filesystem.

To set a quote, use zfs set command as shown below. Here we are specifying the quota as 1GB for this filesystem.

<b>master:</b> `zfs set quota=1G zfspool0/vol0`{{execute HOST1}}

<b>node01:</b> `zfs set quota=1G zfspool0/vol0`{{execute HOST2}}

Next, set the reservation for the filesystem. We will reserve 256M out of 47.7G so that no one can use this space and also it can extend up to 1G based on the quota we set if there is free space available.

<b>master:</b> `zfs set reservation=256M zfspool0/vol0`{{execute HOST1}}

<b>node01:</b> `zfs set reservation=256M zfspool0/vol0`{{execute HOST2}}

## Enable Compression on ZFS Filesystem
To set compression on a ZFS dataset, you can set the compression property as shown below. Once this property is set, any large files stored on this ZFS filesystem will be compressed.

<b>master:</b> `zfs set compression=lzjb zfspool0/vol0`{{execute HOST1}}

<b>node01:</b> `zfs set compression=lzjb zfspool0/vol0`{{execute HOST2}}




