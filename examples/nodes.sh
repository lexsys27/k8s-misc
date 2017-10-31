# get the list of nodes
kubectl get nodes

# One can assign labels to the nodes
kubectl label nodes node2 shouldrun=here

# Create the pod that runs on the particular node
cat > pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: onspecificnode
spec:
  containers:
  - name: sise
    image: mhausenblas/simpleservice:0.5.0
    ports:
    - containerPort: 9876
  nodeSelector:
    shouldrun: here
EOF

# Learn more about your node
kubectl describe node node2

