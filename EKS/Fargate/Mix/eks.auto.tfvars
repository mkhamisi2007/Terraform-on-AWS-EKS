cluster_name                         = "my_eks_cluster"
cluster_service_ipv4_cidr            = "172.20.0.0/16"
eks_cluster_version                  = "1.35"
cluster_endpoint_private_access      = false
cluster_endpoint_public_access       = true
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
