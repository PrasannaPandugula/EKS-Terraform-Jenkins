#VPC variables
variable "cluster-name" {}
variable "cidr-block" {}
variable "vpc-name"  {}
variable "env" {}

variable "igw-name" {}
variable "pub-subnet-count" {}
variable "pub-cidr-block" {
    type = list(string)
}
variable "pub-availability-zone" {
    type = list(string)
}
variable "pub-sub-name" {}

variable "pri-sub-name" {}
variable "pri-cidr-block" {
    type = list(sting)
}
variable "pri-availability-zone" {
    type = list(sting)
}
variable "public-rt-name" {}
variable "eip-name" {}
variable "ngw-name" {}
variable "pri-rt-name" {}
variable "eks-sg" {}

# Iam var
variable "is-eks-role-enabled" {
  type = bool
}

variable "is-eks-nodegroup-role-enabled" {
  type = bool
}

# EKS var
variable "is-eks-cluster-enabled" {}
variable "cluster-version" {}
variable "endpoint-private-access" {}
variable "endpoint-public-access" {}
variable "addons" {
  type = list(object({
    name = string
    version = string
  }))
}

variable "desired_capacity_on_demand" {  
}
variable "min_capacity_on_demand" {  
}
variable "max_capacity_on_demand" {
}
variable "ondemand_instance_type" {
}
variable "desired_capacity_spot" {
}
variable "min_capacity_spot" {
}
variable "max_capacity_spot" {
}
variable "spot_instance_type" {
}