# Environmental variables

cat > env.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: envs
spec:
  containers:
  - name: sise
    image: mhausenblas/simpleservice:0.5.0
    ports:
    - containerPort: 9876
    env:
    - name: SIMPLE_SERVICE_VERSION
      value: "1.0"
EOF

kubectl describe pod envs | grep IP:
curl 10.44.0.9:9876/info

# Output shows that container picked up environmental variable and showed it
# instead default one 0.5.0

# Print all the environmental variables
curl 10.44.0.9:9876/env

# or do it using kubectl / looks much better!
kubectl exec envs -- printenv


