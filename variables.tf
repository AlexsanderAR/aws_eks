variable "aws_region" {
  default = "us-east-1"
}

variable "aws_instance_types" {
  default = {
    dev = "t3.medium"
    hlg = "t3.medium"
    prd = "t3.medium"
  }
}

variable "eks_scaling_min" {
  default = {
    dev = "1"
    hlg = "1"
    prd = "1"
  }
}

variable "eks_scaling_max" {
  default = {
    dev = "6"
    hlg = "6"
    prd = "6"
  }
}

variable "eks_scaling_desired" {
  default = {
    dev = "2"
    hlg = "2"
    prd = "2"
  }
}

variable "aws_vpc_cidr" {
  default = {
    dev = "172.35.0.0/16"
    hlg = "172.36.0.0/16"
    prd = "172.37.0.0/16"
  }
}

variable "aws_vpc_cidr_halfoctet" {
  default = {
    dev = "172.35"
    hlg = "172.36"
    prd = "172.37"
  }
}

variable "outgoing_ip" {
  default = ["200.203.121.11/32","201.21.6.22/32"]
}

variable "aws_eks_cluster_name" {
  default = "eks-terraform-cluster"
}