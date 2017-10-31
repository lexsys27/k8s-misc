# Kubernetes secrets management

# let's create a secret!
echo -n "A19fh68B001j" > ./apikey.txt
kubectl create secret generic apikey --from-file=./apikey.txt
kubectl describe secrets/apikey

# Now create a pod that uses this secret via volume
cat > pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: consumesec
spec:
  containers:
  - name: shell
    image: centos:7
    command:
      - "bin/bash"
      - "-c"
      - "sleep 10000"
    volumeMounts:
      - name: apikeyvol
        mountPath: "/tmp/apikey"
        readOnly: true
  volumes:
  - name: apikeyvol
    secret:
      secretName: apikey
EOF

# Get into the container
kubectl exec consumesec -c shell -i -t -- bash
$ mount | grep apikey
$ cat /tmp/apikey/apikey.txt

# how to access secret using environmental variables?

