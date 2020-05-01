
## Joining your Node
The nodes are where your workloads (containers and Pods, etc) run. To add a new node to your cluster, we'll use the join command you copied, hopefully, in step 2.  If you don't have the join command, you can generate it again by running the following command on the master node:

`sudo kubeadm token create --print-join-command`{{execute HOST1}}

This will generate a new token and print the join command.  The above command can also be used when adding additional nodes in the future, as by default, tokens are only valid for 24hrs.

The join command needs to be run with root privileges, so place the `sudo` command in front of it.  The command will look like:

`sudo kubeadm join --token <token> 172.17.0.100:6443 --discovery-token-ca-cert-hash sha256:<hash>`

Run the join command on node01 using your particular `token` and `hash` values.

It can take several minutes for the node bootstrap process to complete.

## Check Node Status
Run the command to get the list of nodes:

`kubectl get nodes`{{execute HOST1}}

You should now see node01 in addtion to the master.  It might take a few moments for the node to become ready.  You can repeat the above command to get an updated status.

## List Pods
Have a look at the pods that are now running on the cluster:

`kubectl get pods -A`{{execute HOST1}}

We used the <i>-A</i> as a short form form for <i>--all-namespaces</i>

If we want to see the what nodes the pods are actually running on, we can include the <i>-o wide</i> for wide output:

`kubectl get pods -A -o wide`{{execute HOST1}}

If we only wanted to see pods from a single namespace, such as `kube-system` we can use:

`kubectl get pods -o wide --namespace=kube-system`{{execute HOST1}} or

`kubectl get pods -o wide -n kube-system`{{execute HOST1}} for short.
