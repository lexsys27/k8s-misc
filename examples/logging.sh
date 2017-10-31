# Logs

cat > logme.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: logme
spec:
  containers:
  - name: gen
    image: centos:7
    command:
      - "bin/bash"
      - "-c"
      - "while true; do echo $(date) | tee /dev/stderr; sleep 1; done"
EOF

# View the recent 5 lines of logs
kubectl logs --tail=5 logme -c gen

# To stream the logs
kubectl logs -f --since=10s logme -c gen

# How can one get logs from the stopped containers?
cat > pod-2.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: oneshot
spec:
  containers:
  - name: gen
    image: centos:7
    command:
      - "bin/bash"
      - "-c"
      - "for i in 9 8 7 6 5 4 3 2 1 ; do echo $i ; done"
EOF

# Using -p option you can look at logs from previous instances
kubectl logs -p oneshot -c gen

# Doesn't work for me

