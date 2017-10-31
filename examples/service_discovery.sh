
cat > rc.yaml <<EOF
apiVersion: v1
kind: ReplicationController
metadata:
  name: rcsise
spec:
  replicas: 2
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
  name: thesvc
spec:
  ports:
    - port: 80
      targetPort: 9876
  selector:
    app: sise
EOF

# Create a service and replication controller along with some pods
kubectl apply --filename rc.yaml
kubectl apply --filename svc.yaml

# Create a jump pod
cat > jumppod.yaml <<EOF
apiVersion:   v1
kind:         Pod
metadata:
  name:       jumpod
spec:
  containers:
  - name:     shell
    image:    centos:7
    command:
      - "bin/bash"
      - "-c"
      - "sleep 10000"
EOF

# Verify the service is available from the other pods in the cluster
kubectl apply -f jumppod.yaml

kubectl exec jumpod -c shell -i -t -- ping thesvc.default.svc.cluster.local

# We can connect to the service directly
kubectl exec jumpod -c shell -i -t -- curl http://thesvc/info

# FQDN: $SVC.$NAMESPACE.svc.cluster.loca

cat > ns.yaml <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: other
EOF

cat > rc-2.yaml <<EOF
apiVersion: v1
kind: ReplicationController
metadata:
  name: rcsise
  namespace: other
spec:
  replicas: 2
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

cat > svc-2.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: thesvc
  namespace: other
spec:
  ports:
    - port: 80
      targetPort: 9876
  selector:
    app: sise
EOF

kubectl exec jumpod -c shell -i -t -- curl http://thesvc.other/info

# DNS-based service discovery provides a flexible and generic way to connect to
# services across the cluster

