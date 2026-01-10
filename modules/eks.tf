resource "aws_eks_cluster" "eks" {
    count = is-eks-cluster-enabled == true ? 1 : 0
    name = var.cluster-name
    role_arn = aws_iam_role.eks_cluster_role[count.index].arn
    version = var.cluster-version

    access_config {
      authentication_mode = CONFIG_MAP
      bootstrap_cluster_creator_admin_permissions = true
    }

    tags = {
      Name = var.cluster-name
      Env = var.env
    }

    vpc_config {
    endpoint_private_access = var.endpoint-private-access
    endpoint_public_access  = var.endpoint-public-access

    subnet_ids = [
      aws_subnet.private-subnet[0].id,
      aws_subnet.private-subnet[1].id,
      aws_subnet.private-subnet[2].id,
    ]
  }
}

# onde mand node group
resource "aws_eks_node_group" "ondemand-node" {
  cluster_name = aws-eks_cluster[0].name
  node_group_name = "${var.cluster-name}-ondemand-nodes"
  node_role_arn   = aws_iam_role.eks_nodegroup_role[0].arn
  subnet_ids = [
      aws_subnet.private-subnet[0].id,
      aws_subnet.private-subnet[1].id,
      aws_subnet.private-subnet[2].id,
    ]

  scaling_config {
    desired_size = var.desired_capacity_on_demand
    min_size = var.min_capacity_on_demand
    max_size = var.max_capacity_on_demand
  }
  update_config {
    max_unavailable = 1
  }
  instance_types = var.ondemand_instance_type
  capacity_type = "ON_DEMAND"
  labels = {
    type = "ondemand"
  }

  tags = {
    Name = "${var.cluster-name}-ondemand-nodes"
  }

  tags_all = {
    "kubernetes.io/cluster/{var.cluster.name}" = "owned"
    Name = "${var.cluster-name}-ondemand-nodes"
  }
  depends_on = [ aws-eks_cluster.eks ]
}

#spot node
resource "aws_eks_node_group" "spot-node" {
  cluster_name = aws-eks_cluster[0].name
  node_group_name = "${var.cluster-name}-spot-nodes"
  node_role_arn   = aws_iam_role.eks_nodegroup_role[0].arn

  subnet_ids = [
      aws_subnet.private-subnet[0].id,
      aws_subnet.private-subnet[1].id,
      aws_subnet.private-subnet[2].id,
    ]

  scaling_config {
    desired_size = var.desired_capacity_spot
    min_size = var.min_capacity_spot
    max_size = var.max_capacity_spot
  }
  update_config {
    max_unavailable = 1
  }
  
  instance_types = var.spot_instance_type
  capacity_type = "SPOT"
  
  tags = {
    Name = "${var.cluster-name}-spot-nodes"
  }

  tags_all = {
    "kubernetes.io/cluster/{var.cluster.name}" = "owned"
    Name = "${var.cluster-name}-spot-nodes"
  }
  labels = {
    type = "spot"
    lifecycle = "spot"
  }
  disk_size = 50
  depends_on = [ aws_eks_cluster.eks ]
}

# ODIC
resource "aws_iam_openid_connect_provider" "ODIC" {
  client_id_list = [sts.amazonaws.com]
  thumbprint_list = [data.tls_certificate.eks-certificate.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.eks-certificate.url
}

#addons for EKS cluster
resource "aws_eks_addon" "eks-addons" {
  for_each = { for idx, addon in var.addons : idx => addon }
  cluster_name = aws_eks_cluster[0].name
  addon_name = each.value.name
  addon_version = each.value.version

  depends_on = [ aws_eks_node_group.on ]
}

