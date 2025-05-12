terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.29"

  # VPC integration
  vpc_id     = module.myApp-vpc.vpc_id
  subnet_ids = module.myApp-vpc.private_subnets

  # Cluster endpoint access
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Enable common AWS-managed addons
  cluster_addons = {
    coredns   = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni   = { most_recent = true }
  }

  # Managed node group definition
  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1

      # Pick one instance type (no duplicates)
      instance_types = ["t2.small"]

      capacity_type = "ON_DEMAND"
      key_name      = "sannikp"
    }
  }

  # Tags applied to all resources
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Application = "myApp"
  }
}
