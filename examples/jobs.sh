# Jobs - run batch operations

# create job that counts
cat > job.yaml <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: countdown
spec:
  template:
    metadata:
      name: countdown
    spec:
      containers:
      - name: counter
        image: centos:7
        command:
         - "bin/bash"
         - "-c"
         - "for i in 9 8 7 6 5 4 3 2 1 ; do echo $i ; done"
      restartPolicy: Never
EOF

# List the jobs
kubectl get jobs

# Show me the pods
kubectl get pods --show-all

# Show me the status of the job
kubectl describe jobs/countdown

# Logs should be available but I can't see them
kubectl logs countdown-xwm8g

# Clean up
kubectl delete job countdown

