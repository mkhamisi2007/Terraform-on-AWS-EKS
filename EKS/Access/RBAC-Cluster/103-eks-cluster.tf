resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn #--> master role
  version  = var.eks_cluster_version
  vpc_config {
    subnet_ids              = module.vpc.public_subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }
  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr #--> cluster service ipv4 cidr
  }
  # control plane logging to send logs to cloudwatch
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP" #--> API or CONFIG_MAP
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role_policy_attachment,
    aws_iam_role_policy_attachment.eks_service_role_policy_attachment
  ]
}



#------------------- EKS Cluster Variables ------------------#
variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = "eksdemo"
}
variable "cluster_service_ipv4_cidr" {
  description = "service ipv4 cidr for the kubernetes cluster"
  type        = string
  default     = "172.20.0.0/16"
}
variable "eks_cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.34"
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. When it's set to `false` ensure to have a proper private access with `cluster_endpoint_private_access = true`."
  type        = bool
  default     = true
}
variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
