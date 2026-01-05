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
variable "is_eks_role_enabled" {
  type = bool
}

variable "is_eks_nodegroup_role_enabled" {
  type = bool
}