module "elasticache-redis" {
  source  = "cloudposse/elasticache-redis/aws"
  version = "1.2.2"
  vpc_id  = module.vpc.vpc_id

  description = "test"

  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  #zone_id                    = var.zone_id # route53
  allowed_security_group_ids = [module.sg_eks_worker.id] # security group allowed
  subnets                    = module.redis-subnets.private_subnet_ids
  cluster_size               = 2
  #instance_type              = var.instance_type
  apply_immediately          = true
  automatic_failover_enabled = false
  #engine_version             = var.engine_version
  #family                     = var.family
  at_rest_encryption_enabled = false
  transit_encryption_enabled = false
  replication_group_id       = "r1"

  parameter_group_name = "redis"

  context = module.this.context
}