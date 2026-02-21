EKS Cluster (<cluster-name>)
└── VPC
    ├── Subnets  
    │   ├── Public Subnets
    │   │   ├── kubernetes.io/cluster/<cluster-name> = shared|owned
    │   │   └── kubernetes.io/role/elb = 1
    │   └── Private Subnets
    │       ├── kubernetes.io/cluster/<cluster-name> = shared|owned
    │       └── kubernetes.io/role/internal-elb = 1
    │
    ├── Security Groups (گاهی برای Discovery/مدیریت)
    │   ├── kubernetes.io/cluster/<cluster-name> = shared|owned   (اختیاری ولی رایج)
    │   └── karpenter.sh/discovery = <cluster-name>              (اگر Karpenter)
    │
    └── Worker Nodes / NodeGroups / ASG
        ├── (ASG tags برای Autoscaling)
        │   ├── k8s.io/cluster-autoscaler/enabled = true
        │   └── k8s.io/cluster-autoscaler/<cluster-name> = owned
        └── (اختیاری: تگ‌های مدیریتی مثل Name/Env/CostCenter)
--------------------------------Subnet-----------------------------------------
kubernetes.io/cluster/<cluster-name> = shared   (OR owned)
#---Public subnet(expternal-load balancer)
kubernetes.io/role/elb = 1
#---Private subnet(internal-load balancer)
kubernetes.io/role/internal-elb = 1
------------------------------Security Group-----------------------------------
kubernetes.io/cluster/<cluster-name> = owned|shared
----------------------Auto Scaling Group / NodeGroup---------------------------
k8s.io/cluster-autoscaler/enabled = true
k8s.io/cluster-autoscaler/<cluster-name> = owned
-------------------------------Karpenter---------------------------------------
karpenter.sh/discovery = <cluster-name>









