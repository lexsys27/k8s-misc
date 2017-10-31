# List namespaces
kubectl get ns

kubectl describe ns default

cat > ns.yaml <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: test
EOF

kubectl apply -f ns.yaml

kubectl get ns

cat > pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: podintest
spec:
  containers:
  - name: sise
    image: mhausenblas/simpleservice:0.5.0
    ports:
    - containerPort: 9876
EOF

kubectl apply -f pod.yaml

# Deploy to the namespace test
kubectl create --namespace=test -f pod.yaml

# List pods in the test namespace
kubectl get pods --namespace=test

