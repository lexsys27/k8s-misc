# Health checks, or probes as they are called in Kubernetes, are carried out by
# the kubelet to determine when to restart a container (for livenessProbe) and
# by services to determine if a pod should receive traffic or not (for
# readinessProbe).

cat > pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: hc
spec:
  containers:
  - name: sise
    image: mhausenblas/simpleservice:0.5.0
    ports:
    - containerPort: 9876
    livenessProbe:
      initialDelaySeconds: 2
      periodSeconds: 5
      httpGet:
        path: /health
        port: 9876
EOF

kubectl apply --filename pod.yaml
kubectl describe pod hc

cat > badpod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: badpod
spec:
  containers:
  - name: sise
    image: mhausenblas/simpleservice:0.5.0
    ports:
    - containerPort: 9876
    env:
    - name: HEALTH_MIN
      value: "1000"
    - name: HEALTH_MAX
      value: "4000"
    livenessProbe:
      initialDelaySeconds: 2
      periodSeconds: 5
      httpGet:
        path: /health
        port: 9876
EOF

# Bad pod randomly does not return 200 code
kubectl apply -f badpod.yaml
kubectl describe badpod

# Verify container is restarted by scheduler
kubectl get pods

# redisnessProbe is used to check the start-up phase of a container in the pod

cat > ready.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: ready
spec:
  containers:
  - name: sise
    image: mhausenblas/simpleservice:0.5.0
    ports:
    - containerPort: 9876
    readinessProbe:
      initialDelaySeconds: 10
      httpGet:
        path: /health
        port: 9876
EOF

kubectl apply -f ready.yaml
kubectl describe pod ready

# There are also TCP and command probes

