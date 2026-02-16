clouds provider , kubernetes , Active Directory , DNS , ....
https://registry.terraform.io/browse/providers
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
-----------------------------------------------------------------------------------------------------------------------------------AWS & Kubernetes
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

#################################
# AWS PROVIDER
#################################

provider "aws" {
  region = "eu-west-3" # Paris
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # فقط مثال
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-ec2"
  }
}

#################################
# KUBERNETES PROVIDER
#################################

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "terraform-namespace"
  }
}
