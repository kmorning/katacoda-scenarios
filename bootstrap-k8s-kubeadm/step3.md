You must deploy a Container Network Interface (CNI) based Pod network add-on so that your Pods can communicate with each other.  Cluster DNS (CoreDNS) will not start up before a network is installed.

There are several pod network addons we can choose from, each with there own.  We're going to use the Weave Net addon which provides a good balance between functionality and simple setup.

## Install the Weave Net CNI Plugin

Weave Net can be installed onto your CNI-enabled Kubernetes cluster with a single command:

`kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"`

However, we're going to pass a couple of extra configuration options:

`IPALLOC_RANGE` - the range of IP addresses used by Weave Net and the subnet they are placed in (CIDR format; default 10.32.0.0/12)

`NO_MASQ_LOCAL` - set to 1 to preserve the client source IP address when accessing services that have external traffic policy set to Local.

We're going to use the ip address range of "172.28.0.0/16" for the pod network.  In a production environment, the pod network must not overlap with any of the host networks. You are likely to see problems if there is any overlap.

Install weave net using the command below:

`curl -SL "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=172.28.0.0/16&env.NO_MASQ_LOCAL=1" | kubectl apply -f -`{{execute HOST1}}

## Check the Node Status
Use the command below to check the status of the master node, now that pod network is intalled.  You might need to issue it a few times, but eventually the master node should show as `Ready`.

## Show Pods
The following command will show all the pods in the Kubernetes cluster.  They should all be in the `Running` state right now.

`kubectl get pods --all-namespaces`{{execute HOST1}}

We add the <i>--all-namespaces</i> argument to the get command, as kubernetes can have many namespaces, and if the argument was left out, only pods running in the default namespace would be shown.  Right now, we only have pods running in the `kube-system` namespace.  `kube-system` is the namespace for objects created by the Kubernetes system.  It will run the pods necessary for the control-plane, api server, dns, scheduling and networking.

