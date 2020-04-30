The Kubernetes components have been pre-installed onto both the master and worker nodes, however, they are quite out of date now.  In this step we'll check the current version of Kubernetes installed, and upgrade it to a more recent version.

## Check the current version
 The command below will return the version of kubeadm installed, which in turn will tell us the version of all the Kubernetes components.  Run the following command on the master node:

 `kubeadm version`{{execute T1}}

