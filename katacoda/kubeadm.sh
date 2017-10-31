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

# How to schedule containers to the master node?
kubectl taint nodes --all node-role.kubernetes.io/master-

# Sample application deployment
kubectl create namespace sock-shop
kubectl apply -n sock-shop -f "https://github.com/microservices-demo/microservices-demo/blob/master/deploy/kubernetes/complete-demo.yaml?raw=true"

# Find out the port application is listening
kubectl -n sock-shop get svc front-end
# 10.101.50.164:30001

# Verify everything is running
kubectl get pods -n sock-shop

# How to do port forwarding on kalico playground?
# Select menu item and type in the port number

# Clean up the example application
kubectl delete namespace sock-shop

