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

resource "aws_iam_role_policy" "eks_network_policy" {
  name = "eks-network-policy"
  role = aws_iam_role.eks_node_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:UnassignPrivateIpAddresses",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:DetachNetworkInterface",
          "ec2:DescribeTags",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DeleteNetworkInterface",
          "ec2:CreateNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:AssignPrivateIpAddresses"
        ],
        "Resource": "*",
        "Sid": "IPV4"
      },
      {
        "Effect": "Allow",
        "Action": "ec2:CreateTags",
        "Resource": "arn:aws:ec2:*:*:network-interface/*",
        "Sid": "CreateTags"
      }
    ]
  })
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name = aws_eks_cluster.eks.name
  node_group_name = "my-node-group"
  node_role_arn = aws_iam_role.eks_node_role.arn
  subnet_ids = [aws_subnet.subnet_private_1.id, aws_subnet.subnet_private_2.id]

  scaling_config {
    min_size = 2
    max_size = 4
    desired_size = 2
  }

  instance_types = ["t3.medium"]
}

