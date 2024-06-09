resource "aws_iam_role" "eks_lb_controller_role" {
  name               = "eks-load-balancer-controller-role"
  assume_role_policy = data.aws_iam_policy_document.eks_lb_controller_assume_role.json
}

resource "aws_iam_policy" "eks_lb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "Policy for the AWS Load Balancer Controller"

  policy = file("${path.module}/iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "eks_lb_controller_role_attachment" {
  policy_arn = aws_iam_policy.eks_lb_controller_policy.arn
  role       = aws_iam_role.eks_lb_controller_role.name
}

resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_lb_controller_role.arn
    }
  }

  automount_service_account_token = true
}

resource "aws_iam_role" "gitlab_role" {
  name = "gitlab_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "gitlab_profile" {
  name = "gitlab_profile"
  role = aws_iam_role.gitlab_role.name
}

resource "aws_iam_policy" "access_policy" {
  for_each = local.iam_policy
  name     = each.key
  policy   = each.value
}

resource "aws_iam_role_policy_attachment" "access_policy_attachment" {
  for_each   = local.iam_attachment
  policy_arn = each.key
  role       = each.value
}


