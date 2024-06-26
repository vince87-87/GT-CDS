

resource "aws_iam_policy" "eks_lb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "Policy for the AWS Load Balancer Controller"

  policy = file("${path.module}/iam-policy.json")
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
  count      = 2
  policy_arn = local.iam_attachment[count.index]
  role       = aws_iam_role.gitlab_role.name
}


