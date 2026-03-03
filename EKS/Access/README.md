there is 2 type of access
* IAM → aws-auth ConfigMap → Kubernetes Group → RBAC (old)
* IAM → EKS Access Entry → EKS Access Policy → RBAC (new)

NEW
<img width="914" height="434" alt="image" src="https://github.com/user-attachments/assets/0d95f0e1-8050-466e-97b9-1fb401c51c2e" />
<img width="1004" height="560" alt="image" src="https://github.com/user-attachments/assets/476ef92f-e686-41cc-b2d3-c7b48c4c0805" />
<img width="939" height="539" alt="image" src="https://github.com/user-attachments/assets/cebd7e88-a009-4779-8f00-096524f93fbf" />

OLD
```cmd
kubectl edit configmap aws-auth -n kube-syste
```
```diff
apiVersion: v1
data:
+  mapRoles: |
+    - rolearn: arn:aws:iam::XXXXXXXXXXXXX:role/eks-nodegroup-role
+      groups:
+      - system:bootstrappers
+      - system:nodes
+      username: system:node:{{EC2PrivateDNSName}}
kind: ConfigMap
metadata:
  creationTimestamp: "2026-03-03T14:31:53Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "842"
  uid: 00461c55-b54f-34c3-b3a3-9e1cbe56186e
```
<img width="840" height="445" alt="image" src="https://github.com/user-attachments/assets/e3c910b3-287b-4d18-9f48-5fbd6b8d4253" />
