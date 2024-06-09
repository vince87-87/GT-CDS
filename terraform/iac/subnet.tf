module "web_app-subnets" {
  source                  = "cloudposse/dynamic-subnets/aws"
  version                 = "2.4.2"
  vpc_id                  = module.vpc.vpc_id
  igw_id                  = [module.vpc.igw_id]
  max_subnet_count        = 2
  private_subnets_enabled = true
  public_subnets_enabled  = true
  public_label            = "web-public"
  private_label           = "app-private"
  nat_gateway_enabled     = true
  ipv4_cidrs = [
    {
      public  = ["10.0.1.0/24", "10.0.2.0/24"]
      private = ["10.0.3.0/24", "10.0.4.0/24"]
    }
  ]
  public_subnets_additional_tags = {
    "kubernetes.io/cluster/cds-cluster" = "owned"
    "kubernetes.io/role/elb"            = "1"
  }

  private_subnets_additional_tags = {
    "kubernetes.io/cluster/cds-cluster" = "owned"
    "kubernetes.io/role/internal-elb"   = "1"
  }
}

# module "app-subnets" {
#   source                  = "cloudposse/dynamic-subnets/aws"
#   version                 = "2.4.2"
#   vpc_id                  = module.vpc.vpc_id
#   igw_id                  = [module.vpc.igw_id]
#   max_subnet_count        = 2
#   private_label           = "app-private"
#   private_subnets_enabled = true
#   public_subnets_enabled  = false
#   nat_gateway_enabled     = false
#   ipv4_cidrs = [
#     {
#       private = ["10.0.3.0/24", "10.0.4.0/24"]
#       public  = []
#     }
#   ]

#   tags = {
#     "kubernetes.io/cluster/cds-cluster" = "owned"
#     "kubernetes.io/role/internal-elb" = "1"
#   }
# }

module "redis-subnets" {
  source                  = "cloudposse/dynamic-subnets/aws"
  version                 = "2.4.2"
  vpc_id                  = module.vpc.vpc_id
  igw_id                  = [module.vpc.igw_id]
  max_subnet_count        = 2
  private_label           = "redis-private"
  private_subnets_enabled = true
  public_subnets_enabled  = false
  nat_gateway_enabled     = false
  ipv4_cidrs = [
    {
      private = ["10.0.5.0/24", "10.0.6.0/24"]
      public  = []
    }
  ]
}