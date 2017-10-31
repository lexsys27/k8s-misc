Kubernetes interactive playground
=================================

Playground is available at [https://play-with-k8s.com].

Let's create a new node.

Now bootstrap a cluster:

```
# Create master node
kubeadm init --apiserver-advertise-address $(hostname -i)

# Set up weave networking
kubectl apply -n kube-system -f \
    "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Install dashboard
curl -L -s https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml  | sed 's/targetPort: 8443/targetPort: 8443\n  type: LoadBalancer/' | kubectl apply -f -
```

Now add two new nodes and add them to the cluster:

```
kubeadm join --token 48afb7.7cf928d49e55c3d0 10.0.21.3:6443
```

Now click on a small icon with the port number and go to kubernetes dashboard.
To authenticate use the token you got after master init. You need to copy link
and then add https:// before it for forwarding to work.

Finally you have a small k8s cluster you can use to test things!
