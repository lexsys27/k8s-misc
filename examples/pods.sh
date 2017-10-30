# Launch a pod
# docker image for the container: --image
# expose port 9876
kubectl run sise --image=mhausenblas/simpleservice:0.5.0 --port=9876

# List all the pods
kubectl get pods

POD_NAME=$(kubectl get pods -l run=sise -o jsonpath="{.items[0].metadata.name}")
kubectl describe pod $POD_NAME | grep IP:
# > IP:             10.200.1.4

# run from controller or worker node
curl 10.200.1.4:9876/info | jq .

# Use config file to create a pod
cat > pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: twocontainers
spec:
  containers:
  - name: sise
    image: mhausenblas/simpleservice:0.5.0
    ports:
    - containerPort: 9876
  - name: shell
    image: centos:7
    command:
      - "bin/bash"
      - "-c"
      - "sleep 10000"
EOF

kubectl create -f pod.yaml
kubectl get pods

# Exec into the container and access the service using localhost
kubectl exec twocontainers -c shell -i -t -- bash
curl -s localhost:9876/info

# How to constrain the resources available for the container
cat > constrained-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: constraintpod
spec:
  containers:
  - name: sise
    image: mhausenblas/simpleservice:0.5.0
    ports:
    - containerPort: 9876
    resources:
      limits:
        memory: "64Mi"
        cpu: "500m"
EOF

kubectl create -f constrained-pod.yaml
kubectl get pods


