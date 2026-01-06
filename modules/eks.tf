resource "aws_eks_cluster" "eks" {
    count = is-eks-cluster-enabled == true 1 : 0
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

# ODIC
resource "aws_iam_openid_connect_provider" "ODIC" {
  client_id_list = [sts.amazonaws.com]
  thumbprint_list = [data.tls_certificate.eks-certificate.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.eks-certificate.url
}