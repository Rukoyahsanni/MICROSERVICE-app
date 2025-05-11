provider "aws" {
    region = "us-east-1"
}

variable vpc_cidr_block {}
variable private_subnet {}
variable public_subnet {}

data "aws_availability_zones" "available" {}


module "myApp-vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.0.0"

    name = "myApp-vpc"
    cidr = var.vpc_cidr_block
    private_subnets = var.private_subnet
    public_subnets = var.public_subnet
    azs = data.aws_availability_zones.available.names 
    
    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true

    tags = {
        "kubernetes.io/cluster/myAppp-eks-cluster" = "shared"
    }

    public_subnet_tags = {
        "kubernetes.io/cluster/myAppp-eks-cluster" = "shared"
        "kubernetes.io/role/elb" = 1 
    }

    private_subnet_tags = {
        "kubernetes.io/cluster/myAppp-eks-cluster" = "shared"
        "kubernetes.io/role/internal-elb" = 1 
    }

}