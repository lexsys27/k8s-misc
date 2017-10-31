# A Kubernetes volume is essentially a directory accessible to all containers running in a pod
# Types
# node-local types such as emptyDir or hostPath
# file-sharing types such as nfs
# cloud provider-specific types like awsElasticBlockStore, azureDisk, or gcePersistentDisk
# distributed file system types, for example glusterfs or cephfs
# special-purpose types like secret, gitRepo

# Create a pod with two containers that use emptyDir volume for data exchange

cat > pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: sharevol
spec:
  containers:
  - name: c1
    image: centos:7
    command:
      - "bin/bash"
      - "-c"
      - "sleep 10000"
    volumeMounts:
      - name: xchange
        mountPath: "/tmp/xchange"
  - name: c2
    image: centos:7
    command:
      - "bin/bash"
      - "-c"
      - "sleep 10000"
    volumeMounts:
      - name: xchange
        mountPath: "/tmp/data"
  volumes:
  - name: xchange
    emptyDir: {}
EOF

kubectl describe pod sharevol

# Get shell inside the first container
kubectl exec sharevol -c c1 -i -t -- bash
$ mount | grep xchange
$ echo 'some data' > /tmp/xchange/data

# We have written some data to the volume in the first container. Let's read it
# from the second container

kubectl exec sharevol -c c2 -i -t -- bash
$ cat /tmp/data/data

# Note that directory is node-specific and you can't exchange data between the
# pods this way.

