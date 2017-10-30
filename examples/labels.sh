# Labels are the mechanism you use to organize Kubernetes objects

cat > label-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: labelex
  labels:
    env: development
spec:
  containers:
  - name: sise
    image: mhausenblas/simpleservice:0.5.0
    ports:
    - containerPort: 9876
EOF

kubectl create -f label-pod.yaml
kubectl get pods --show-labels

# Add label from the console
kubectl label pods labelex owner=lexsys
kubectl get pods --show-labels

# Filter pods based on label
kubectl get pods --selector owner=lexsys
kubectl get pods -l env=development

cat > label-pod-2.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: labelexother
  labels:
    env: production
    owner: lexsys
spec:
  containers:
  - name: sise
    image: mhausenblas/simpleservice:0.5.0
    ports:
    - containerPort: 9876
EOF

kubectl create -f label-pod-2.yaml

# show the pods that are either in production or in development
kubectl get pods -l 'env in (production, development)'

