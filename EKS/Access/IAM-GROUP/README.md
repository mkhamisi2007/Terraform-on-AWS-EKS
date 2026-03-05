in this code we create a group and add a user to it that cat assume role and access our EKS cluster

the role can access out EKS cluster

for access the cluster the users must be 
* added to the group
* asuum role(eks-admin-role) when they want access the cluster

<img width="853" height="447" alt="image" src="https://github.com/user-attachments/assets/ac4af736-d11d-43bc-8042-16fb9dab957c" />


<img width="1060" height="542" alt="image" src="https://github.com/user-attachments/assets/b3ff5486-0abb-4740-9f28-b294791f6b33" />

Group policy
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sts:AssumeRole"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:iam::**********:role/eks-admin-role",
            "Sid": "AllowAssumeRole"
        }
    ]
}
```

<img width="1060" height="626" alt="image" src="https://github.com/user-attachments/assets/43cdad45-6717-4159-bac6-259109abe49e" />

Role policy
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "eks:*",
                "iam:ListRoles",
                "ssm:GetParameter"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```
Role Trust
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::***********:root"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```
