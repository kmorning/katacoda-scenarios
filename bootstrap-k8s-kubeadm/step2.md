
## Initialize the Control-Plane Node
The `kube admin init` command is used to initialize the control-plane node (or nodes in an HA setup), and run by itself with no other arguments, will default the service cidr network to "10.96.0.0/12" and the dns domain to "cluster.local".  We will use the <pre>--service-cidr</pre> and <pre>--service-dns-domain</pre> arguments to pass our own desired values.  We are using what is called a stacked control-plane, which means our master node and control-plane node are one in the same, though it's possible to have an external control-plane separate of the master.  It's also possible to have mutliple control-planes/masters for a high-availibility cluster.

On the master node, execute the following to initialize the control plane:

`sudo kubeadm init --service-cidr "172.29.0.0/16" --service-dns-domain "k8s.example.local"`{{execute HOST1}}

After the pre-flight checks and initialization complete, you'll be given the command needed to join the worker nodes, which will look like the following, but with unique tokens generated during the initialization.

<pre>kubeadm join 172.17.0.36:6443 --token gwk650.zt2hppkihpvrltf5 \
    --discovery-token-ca-cert-hash sha256:dfa82bcf36fb444b3d65fe526528afa7010a2b3de6a40bbe400eb9a4e316944a</pre>

Make sure to copy that command somewhere as we'll need to use it in a following step.

The token is used for mutual authentication between the control-plane node and the joining nodes. The token included here is secret. Keep it safe, because anyone with this token can add authenticated nodes to your cluster.

## Setup Kubectl for the Current User
To make kubectl work for your non-root user, run these commands, which are also part of the `kubeadm init` output:

`mkdir -p $HOME/.kube`{{execute HOST1}}
`sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config`{{execute HOST1}}
`sudo chown $(id -u):$(id -g) $HOME/.kube/config`{{execute HOST1}}

Keep in might that the config copied above contains private keys which gives full control of the cluster to any user who has ownership of it.  In a production environment, this should kept safe and only given to users that administer the cluster.

## Check Node Status
The nodes can be listed using:

`kubectl get nodes`{{exec HOST1}}

For now, the cluster consists of only a single master node.  It's status is shown as `NotReady`, as we still need to install a pod network add-on.



curl -SL "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=172.28.0.0/16&env.NO_MASQ_LOCAL=1" | kubectl apply -f -