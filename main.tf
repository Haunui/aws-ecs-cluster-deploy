module "base" {
  source = "./base"

  prefix = local.prefix
  region = local.region
  subnets = local.subnets
  security_groups = local.security_groups
}

module "ecs_cluster" {
  source = "./ecs_cluster"

  prefix = local.prefix
  region = local.region
  iam_role = local.iam_role

  subnet_ids = module.base.subnet_ids
  security_group_ids = module.base.security_group_ids
}
