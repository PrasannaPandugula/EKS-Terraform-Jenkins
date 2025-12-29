# vpc, igw, subnet, route table, route table association 

locals {
  cluster-name = var.cluster-name
}

resource "aws_vpc" "vpc" {
    cidr_block = var.cidr-block
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = var.vpc-name
      Env = var.env
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw-name
    Env = var.env
    "kubernetes.io/cluster/${local.name}" = "owned"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "public-subnet" {
  count = var.pub-subnet-count
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.pub-cidr-block, count.index)
  availability_zone = element(var.pub-availability-zone)

  tags = {
    Name = "${var.pub-sub-name}-${count-index + 1}"
    Env = var.env
    "kubernetes.io/cluster/${local.name}" = "owned"
  }
}