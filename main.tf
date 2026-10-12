data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name = "${var.project}-${var.environment}"
  azs  = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

module "vpc" {
  source = "./modules/vpc"

  name               = local.name
  region             = var.region
  cidr_block         = var.vpc_cidr
  azs                = local.azs
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  enable_flow_logs   = var.enable_flow_logs
}

module "compute" {
  source = "./modules/compute"
  count  = var.create_instances ? 1 : 0

  name              = local.name
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  private_subnet_id = module.vpc.private_subnet_ids[0]
  instance_type     = var.instance_type
  key_name          = var.key_name
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
}
