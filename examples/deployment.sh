cat > deploy.yaml <<EOF
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: sise-deploy
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: sise
    spec:
      containers:
      - name: sise
        image: mhausenblas/simpleservice:0.5.0
        ports:
        - containerPort: 9876
        env:
        - name: SIMPLE_SERVICE_VERSION
          value: "0.9"
EOF

kubectl create --filename deploy.yaml

# Show existing deployments
kubectl get rs

# Show pods inside the deployment
kubectl get pods

kubectl describe pod sise-deploy-7466dcd6c-9jrrk | grep IP:
#> IP:             10.200.0.5

# from the worker node
curl 10.200.0.5:9876/info | jq .

# diff d10.yaml d09.yaml
# 19c19
# <           value: "1.0"
# ---
# >           value: "0.9"

# Upgrade to the next version
kubectl apply --filename deploy.yaml

# See two pods terminating and two new pods running
kubectl get pods

# New replica set was created
kubectl get rs

# Check the status of deployment
kubectl rollout status deploy/sise-deploy

# Now the version is 0.10

kubectl describe pod sise-deploy-5c854d65f7-lx7nw | grep IP:
#> IP:             10.200.1.9

curl 10.200.1.9:9876/info | jq .

# To see the history of the deployments
kubectl rollout history deploy/sise-deploy

# How to rollback to the previous version
kubectl rollout undo deploy/sise-deploy --to-revision=1
kubectl rollout history deploy/sise-deploy
# This will create another revision not rewrite history
kubectl get pods

# Clean up
kubectl delete deploy sise-deploy
