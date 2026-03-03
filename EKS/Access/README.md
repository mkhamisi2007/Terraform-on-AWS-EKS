```cmd
kubectl edit configmap aws-auth -n kube-syste
```
```yaml
apiVersion: v1
data:
  mapRoles: |
    - rolearn: arn:aws:iam::XXXXXXXXXXXXX:role/eks-nodegroup-role
      groups:
      - system:bootstrappers
      - system:nodes
      username: system:node:{{EC2PrivateDNSName}}
kind: ConfigMap
metadata:
  creationTimestamp: "2026-03-03T14:31:53Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "842"
  uid: 00461c55-b54f-34c3-b3a3-9e1cbe56186e
```
<img width="840" height="445" alt="image" src="https://github.com/user-attachments/assets/e3c910b3-287b-4d18-9f48-5fbd6b8d4253" />
