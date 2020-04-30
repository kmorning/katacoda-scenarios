The Kubernetes components have been pre-installed onto both the master and worker nodes, however, they are quite out of date now.  In this step we'll check the current version of Kubernetes installed and upgrade it to a more recent version.

## Check the current version
 The command below will return the version of kubeadm installed, which in turn will tell us the version of all the Kubernetes components.  Run the following command on the master node:

 `kubeadm version`{{execute HOST1}}

 The result will look something like:

 <pre>kubeadm version: &version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.0", GitCommit:"641856db18352033a0d96dbc99153fa3b27298e5", GitTreeState:"clean", BuildDate:"2019-03-25T15:51:21Z", GoVersion:"go1.12.1", Compiler:"gc", Platform:"linux/amd64"}</pre>

 Looking at the `GitVersion`, you can see kubernetes is at version 1.14.0

## Update the Ubuntu Package List
To see the latest versions of kubernetes available, we need to first update the Ubuntu package.  On the master node run:

`sudo apt update`{{execute HOST1}}

Repeat the update on the worker node:

`sudo apt update`{{execute HOST2}}

## Check Available Kubernetes Versions
To see the available Kubernetes versions, run the following on either the master or worker node:

`apt-cache madison kubeadm`{{execute HOST1}}

## Upgrade Kubernetes
From the list, will pick the latest version from 1.17.x, which in this case is 1.17.5.  There are new versions available, but we'll save that for a subsequent lesson where we'll upgrade a Kubernetes cluster that is up and running.

Execute the following command on the master node,

`sudo apt install kubeadm=1.17.5-00 kubectl=1.17.5-00 kubelet=1.17.5-00`{{execute HOST1}}

and then on the worker node:

`sudo apt install kubeadm=1.17.5-00 kubectl=1.17.5-00 kubelet=1.17.5-00`{{execute HOST2}}

## Place a Hold on the Kubernetes Components
On a live Kubernetes cluster, we need to follow a set procedure for upgrading, so we want to hold it's current version so that it doesn't get upgraded during an install of another package or server upgrade.

On the master node execute

`apt-mark hold kubeadm kubectl kubelet`{{execute HOST1}} and repeat on the worker node.

`apt-mark hold kubeadm kubectl kubelet`{{execute HOST2}}