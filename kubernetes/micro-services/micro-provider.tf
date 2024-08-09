terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

data "aws_eks_cluster" "sock-cluster" {
  name = "sock-cluster"
}
data "aws_eks_cluster_auth" "sock-cluster_auth" {
  name = "sock-cluster_auth"
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.sock-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.sock-cluster.certificate_authority[0].data)
  version          = "2.16.1"
  config_path = "~/.kube/config"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", "sock-cluster"]
    command     = "aws"
  }
}

resource "kubernetes_namespace" "kube-namespace" {
  metadata {
    name = "sock-shop"
  }
}