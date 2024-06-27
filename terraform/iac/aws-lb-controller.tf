resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.4.4" # Specify the appropriate version

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.eks.id
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws_load_balancer_controller.metadata[0].name
  }
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

resource "aws_iam_role" "eks_lb_controller_role" {
  name               = "eks-load-balancer-controller-role"
  assume_role_policy = data.aws_iam_policy_document.eks_lb_controller_assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks_lb_controller_role_attachment" {
  policy_arn = aws_iam_policy.eks_lb_controller_policy.arn
  role       = aws_iam_role.eks_lb_controller_role.name
}