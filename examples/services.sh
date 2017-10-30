# A service is an abstraction for pods, providing a stable, virtual IP (VIP) address
# Keeping the mapping between the VIP and the pods up-to-date is the job of kube-proxy

cat > rc.yaml <<EOF
apiVersion: v1
kind: ReplicationController
metadata:
  name: rcsise
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

cat > svc.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: simpleservice
spec:
  ports:
    - port: 80
      targetPort: 9876
  selector:
    app: sise
EOF

kubectl apply --filename rc.yaml
kubectl apply --filename svc.yaml

# We have a supervised pod running on the cluster
kubectl get pods -l app=sise

# Look at the service
kubectl get svc
kubectl describe svc simpleservice

# Access pods through the service
curl 10.200.0.8:9876/info | jq .

# Forwarding is done by iptables on the worker nodes of the cluster
sudo iptables-save | grep simpleservice

# Let's scale our services
kubectl scale --replicas=2 rc/rcsise

# Now requests are balanced between two pods with equal probability

