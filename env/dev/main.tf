#vpc
module "vpc" {
  source = modules/subnet-vpc
  vpc_id = var.vpc_id
  vpc_cidr = var.vpc_cidr
  public_cidr = var.public_cidr
  private_cidr = var.private_cidr
  private_vpc_id = var.private_vpc_id
  public_vpc_id = var.public_vpc_id
}

#sg
module "security-group" {
  source = modules/security-groups
  vpc_id = module.vpc.vpc_id
}

#rds-db
module "rds" {
   source = "modules/rds"
   vpc_id = var.vpc_id
   identifier = var.identifier
   allocated_storage = var.allocated_storage
   instance_class = var. instance_class
   engine = var.engine
   db_name = var.db_name
   username = var.username
   password = var.password
   parameter_group_name = var.parameter_group_name
   skip_final_snapshot = var.skip_final_snapshot
   private_subnet_id = var.private_subnet_id
   vpc_security_group_ids = var.vpc_security_group_ids
   db_subnet_group_name = aws_db_subnet_group.rds-subnet-group.name
}

#Bastion_host
module "bastion_host" {
   source = "../../module/bastion_host"
   env = var.env
   ami = var.ami
   key_pair_nm = var.key_pair_nm
   instance_names = var.instance_names #need to write bastion host 
   subnet_id = module.vpc.public_subnet_id
   instance_type = var.instance_type
   vpc_security_group_ids  = [module.security_groups.bastion_sg_id]
   tags = local.common_tags
}


#IAM Module
module "iam" {
   source = "../../module/iam"
   role_name = var.role_name
   policy_name = var.policy_name
   instance_profile_name = var.instance_profile_name
}


#EC2 Module
module "ec2_instance" {
   source = "../../module/ec2_instance"
   env = var.env
   ami = var.ami
   key_pair_nm = var.key_pair_nm
   instance_names = var.instance_names
   instance_type = var.instance_type
   subnet_id  = module.vpc.public_subnet_id
   vpc_security_group_ids  = [module.security_groups.bastion_sg_id]
   iam_instance_profile = module.iam.instance_profile_name
   tags = local.common_tags
   security_group_ids = []
}


#RDS Module
module "rds" {
  source = "../../module/rds"
  db_instance_identifier = var.db_instance_identifier
  db_engine              = var.db_engine
  db_engine_version      = var.db_engine_version
  db_instance_class      = var.db_instance_class
  db_alloct_storage  =  var.db_alloct_storage
  db_username            = var.db_username
  db_password            = var.db_password
  db_subnet_group_name =  var.db_subnet_group_name
  private_subnet_id      = module.vpc.private_subnet_id
  vpc_security_group_ids_rds = [module.security_groups.rds_sg_id]
  tags                   = var.tags
}
