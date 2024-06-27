
module "sg_gitlab_runner" {
  source  = "cloudposse/security-group/aws"
  version = "1.0.1"

  attributes                 = ["gitlab"]
  security_group_description = "Allow trusted ip to ssh"
  create_before_destroy      = true
  allow_all_egress           = true

  rules = [local.allow_ssh_ingress_rule]

  vpc_id = module.vpc.vpc_id

  context = module.label.context
}

module "sg_alb" {
  source  = "cloudposse/security-group/aws"
  version = "1.0.1"

  attributes                 = ["alb"]
  security_group_description = "Allow python flask web access"
  create_before_destroy      = true
  allow_all_egress           = true

  rules = [local.allow_http_ingress_rule]

  vpc_id = module.vpc.vpc_id

  context = module.label.context
}

module "sg_eks_worker" {
  source = "cloudposse/security-group/aws"

  attributes = ["eks"]

  # Allow unlimited egress
  allow_all_egress = true

  rule_matrix = [

    {
      source_security_group_ids = [module.sg_alb.id]
      rules = [
        {
          key         = "eks"
          type        = "ingress"
          from_port   = 5001
          to_port     = 5001
          protocol    = "tcp"
          description = "Allow eks worker nodes access from alb"
        }
      ]
    }
  ]

  vpc_id = module.vpc.vpc_id

  context = module.label.context
}