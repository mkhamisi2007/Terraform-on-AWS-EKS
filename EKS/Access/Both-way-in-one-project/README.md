110-acess-entry.tf -> access_entry (New approch)

108-iam-users.tf , 109-eks-configmap.tf -> Old approch

I Put SNS notification in my configuration and i used a Time delay for fix the problem


k get cm aws-auth -n kube-system -o yaml
```yaml
apiVersion: v1
data:
  mapRoles: |
    - "groups":
      - "system:bootstrappers"
      - "system:nodes"
      "rolearn": "arn:aws:iam::**********:role/eks-nodegroup-role"
      "username": "system:node:{{EC2PrivateDNSName}}"
  mapUsers: |
    - "groups":
      - "system:masters"
      "userarn": "arn:aws:iam::**********:user/eksadmin"
      "username": "eksadmin"
    - "groups":
      - "system:masters"
      "userarn": "arn:aws:iam::**********:user/eksbasic"
      "username": "eksbasic"
immutable: false
kind: ConfigMap
metadata:
  creationTimestamp: "2026-03-04T16:20:01Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "722"
  uid: 725c92dd-2422-4277-b2fb-e971cc50f007
```
