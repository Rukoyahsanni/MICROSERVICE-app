variable "region" {
description = "AWS region"
type = string
default = "us-east-1"
}

variable "public_subnets" {
description = "List of public subnet CIDR blocks"
type = list(string)
}

variable "private_subnets" {
description = "List of private subnet CIDR blocks"
type = list(string)
}
