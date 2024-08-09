terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }

    kubernetes = {
        version = ">= 2.0.0"
        source = "hashicorp/kubernetes"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}


data "aws_eks_cluster" "sock-cluster" {
  name = "sock-cluster"
}
data "aws_eks_cluster_auth" "sock-cluster_auth" {
  name = "sock-cluster_auth"
}


provider "aws" {
  region     = "eu-west-2"
}
