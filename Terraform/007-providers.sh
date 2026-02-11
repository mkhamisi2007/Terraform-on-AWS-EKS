clouds provider , kubernetes , Active Directory , DNS , ....
---------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}
provider "aws" {
  profile = "default"
  region = "us-east-1"
}
# (برای مثال) اگر کلاستر K8s داری، helm باید بداند به کدام کلاستر وصل شود
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
-------------------------------
resource "aws_security_group" "example" {
  provider = aws  #-------------------> connect to aws provider
  name = "example-sg"
}

resource "helm_release" "nginx" {
  provider = helm #-------------------> connect to Helm provider
  name       = "nginx"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
}
