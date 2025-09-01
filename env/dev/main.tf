module "vpc" {
  source = modules/subnet-vpc
  vpc_cidr = var.vpc_cidr
}
