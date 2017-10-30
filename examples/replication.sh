# A replication controller (RC) is a supervisor for long-running pods.

cat > rc.yaml <<EOF
apiVersion: v1
kind: ReplicationController
metadata:
  name: rcex
spec:
  replicas: 1
  selector:
    app: sise
  template:
    metadata:
      name: somename
      labels:
        app: sise
    spec:
      containers:
      - name: sise
        image: mhausenblas/simpleservice:0.5.0
        ports:
        - containerPort: 9876
EOF

kubectl get rc
kubectl get pods --show-labels

# RC keeps track of pods using label app=sise

# Scale up to 3 replicas
kubectl scale --replicas=3 rc/rcex

# delete the replication controller and pods
kubectl delete rc rcex

