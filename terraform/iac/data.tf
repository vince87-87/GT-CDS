locals {
  env = terraform.workspace
  iam_policy = {
    "eks_access_policy" = data.aws_iam_policy_document.eks_policy.json,
    "ecr_access_policy" = data.aws_iam_policy_document.ecr_policy.json
  }

  iam_attachment = ["${aws_iam_policy.access_policy["eks_access_policy"].arn}", "${aws_iam_policy.access_policy["ecr_access_policy"].arn}"]

  allow_ssh_ingress_rule = {
    key         = "ssh"
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow trusted ip to access gitlab runner"
    cidr_blocks = ["195.133.129.156/32"]
  }

  allow_http_ingress_rule = {
    key         = "http"
    type        = "ingress"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    description = "Allow any to access alb"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eks_cluster" "eks" {
  name = module.eks_cluster.eks_cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks_cluster.eks_cluster_id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_iam_policy_document" "eks_lb_controller_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}"]
      type        = "Federated"
    }
  }
}

data "aws_iam_policy_document" "eks_policy" {
  statement {
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:ListNodegroups",
      "eks:DescribeNodegroup",
      "eks:CreateCluster",
      "eks:DeleteCluster",
      "eks:CreateNodegroup",
      "eks:DeleteNodegroup",
      "eks:DescribeNodegroup",
      "eks:UpdateNodegroupConfig",
      "eks:ListUpdates",
      "eks:DescribeUpdate"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:CreateTags",
      "ec2:DeleteTags"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    actions = [
      "ecr:CreateRepository",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DeleteRepository",
      "ecr:DeleteRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
}