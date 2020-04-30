The Kubernetes components have been pre-installed onto both the master and worker nodes, however, they are quite out of date now.  In this step we'll check the current version of Kubernetes installed and upgrade it to a more recent version.

## Check the current version
 The command below will return the version of kubeadm installed, which in turn will tell us the version of all the Kubernetes components.  Run the following command on the master node:

 `kubeadm version`{{execute HOST1}}

 The result will look something like:

 <pre>kubeadm version: &version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.0", GitCommit:"641856db18352033a0d96dbc99153fa3b27298e5", GitTreeState:"clean", BuildDate:"2019-03-25T15:51:21Z", GoVersion:"go1.12.1", Compiler:"gc", Platform:"linux/amd64"}</pre>

 Looking at the `GitVersion`, you can see kubernetes is at version 

## Update the Ubuntu package list
To see the latest versions of kubernetes available, we need to first update the Ubuntu package.  On the master node run:

`sudo apt update`{{execute HOST1}}

Repeat the update on the worker node:

`sudo apt update`{{execute HOST1}}