provider "aws" {
  region = "us-east-1"
}


#vpc
module "custom_modules" {
  source = "../../modules/custom_modules"
  vpc_cidr = var.vpc_cidr
  public_cidr = var.public_cidr
  private_cidr_a = var.private_cidr_a
  private_cidr_b = var.private_cidr_b
  subnet_id = var.public_subnet_id
  azs = var.azs[*]

  #ec2-instance
  ami = var.ami
  instance_type = var.instance_type
  key_pair_nm = var.key_pair_nm


#rds-db
  identifier            = var.identifier
  allocated_storage      = var.allocated_storage
  instance_class         = var.instance_class
  engine                 = var.engine
  db_name                = var.db_name
  parameter_group_name   = var.parameter_group_name
  username               = var.username
  password               = var.password
  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = var.vpc_security_group_ids
  
#iam
  policy_name           = var.policy_name
  role_name             = var.role_name
  instance_profile_name = var.instance_profile_name


}
