resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name = aws_eks_cluster.eks.name
  node_group_name = "my-node-group"
  node_role_arn = aws_iam_role.eks_node_role.arn
  subnet_ids = var.subnet_ids

  scaling_config {
    min_size = 2
    max_size = 4
    desired_size = 2
  }

  instance_types = ["t3.medium"]
}

