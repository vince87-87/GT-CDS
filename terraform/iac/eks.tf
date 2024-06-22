module "eks_cluster" {
  source  = "cloudposse/eks-cluster/aws"
  version = "2.2.0"

  region                    = var.region
  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.web_app-subnets.public_subnet_ids
  kubernetes_version        = "1.29"
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  oidc_provider_enabled     = true
  map_additional_iam_roles = [
    {
      rolearn  = "${aws_iam_role.gitlab_role.arn}"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]

  context = module.this.context
}

module "eks-node-group" {
  source  = "cloudposse/eks-node-group/aws"
  version = "v2"

  cluster_name                  = module.eks_cluster.eks_cluster_id
  instance_types                = ["t3.medium"]
  subnet_ids                    = module.web_app-subnets.private_subnet_ids
  desired_size                  = 2
  min_size                      = 2
  max_size                      = 4
  kubernetes_version            = ["1.29"]
  cluster_autoscaler_enabled    = true
  associated_security_group_ids = [module.sg_eks_worker.id]

  context = module.this.context

  module_depends_on = [module.eks_cluster.kubernetes_config_map_id]
}