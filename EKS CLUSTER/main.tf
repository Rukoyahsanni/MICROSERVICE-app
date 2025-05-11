terraform {
required_version = ">= 1.3"
required_providers {
aws = {
source = "hashicorp/aws"
version = "~> 5.0"
}
}
}

provider "aws" {
region = var.region
}

module "vpc" {
source = "terraform-aws-modules/vpc/aws"
version = "~> 5.0"

name = "custom-vpc"
cidr = "10.0.0.0/16"

azs = ["${var.region}a", "${var.region}b", "${var.region}c"]
public_subnets = var.public_subnets
private_subnets = var.private_subnets

enable_nat_gateway = true
single_nat_gateway = true

tags = {
Terraform = "true"
Environment = "dev"
}
}

module "eks" {
source = "terraform-aws-modules/eks/aws"
version = "~> 20.0"

cluster_name = "my-eks-cluster"
cluster_version = "1.29"

subnet_ids = module.vpc.private_subnets
vpc_id = module.vpc.vpc_id

cluster_endpoint_private_access = true
cluster_endpoint_public_access = true

eks_managed_node_groups = {
default = {
desired_size = 2
max_size = 3
min_size = 1
instance_types = ["t2.medium"]
capacity_type = "ON_DEMAND"
}
}

tags = {
Terraform = "true"
Environment = "dev"
}
}
