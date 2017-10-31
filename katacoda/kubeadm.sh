# This is the script of katacoda tutorial on bootstrapping k8s cluster.
# Tutorial is available here: https://www.katacoda.com/courses/kubernetes/getting-started-with-kubeadm

# 1 - Initialise Master
kubeadm init --token=102952.1a7dd4cc8d1f4cc5 --kubernetes-version v1.8.0

# In prod exclude the token to let k8s generate one

# 2 - Join Cluster

# To join the cluster node needs token. You can list all the tokens using
kubeadm token list

# Use this token on another node to join the master
kubeadm join --token=102952.1a7dd4cc8d1f4cc5 172.17.0.42:6443

# 3 - View Nodes

sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf

kubectl get nodes

# Nodes are not ready at this point because netwroking interface is not
# available yet

# 4 - Deploy Container Networking Interface (CNI)

# Use weave
kubectl apply -f /opt/weave-kube

kubectl get pod -n kube-system

# 5 - Deploy Pod

# Create a new pod
kubectl run http --image=katacoda/docker-http-server:latest --replicas=1

# List running pods
kubectl get pods

# From the worker node one can see the containers running
docker ps | grep docker-http-server

# 7 - Deploy Dashboard

kubectl apply -f dashboard.yaml

kubectl get pods -n kube-system


