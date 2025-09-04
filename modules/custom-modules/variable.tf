
variable "name" {
  type = string
  default =  "vpc-head"
}

variable "vpc_cidr" {
   type = string
}

variable "public_cidr" {
   type = string
}

variable "private_cidr_a" {
   type = string
}

variable "private_cidr_b" {
   type = string
}

variable "azs" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_id" {
   type = string
   default = null
}

variable "subnet_id" {
  type = string
}

variable "public_subnet_id" {
   type = string
   default = null
}

variable "private_subnet_id" {
   type = string
   default = null
}

/*variable "cidr_block" {
  type = string
}
*/
#rds-variable

variable "identifier" {
    type = string
 }

variable "allocated_storage" {
   type= number
   default = 20
}
variable "instance_class"  {
    type = string
    default = "db.t3.micro"
}

variable "engine" {
   type = string
   default = "mysql"
}

variable "db_name" {
   type = string
}
variable "parameter_group_name" {
  type = string
  default = "default.mysql8.0"
}

variable "username" {
   type = string
}

variable "password" {
   type = string
   sensitive   = true
}

variable "skip_final_snapshot" {
   type = bool
   default = true
}

variable "vpc_security_group_ids" {
     type = list(string)
     default = [  ]
}
 
#iam-variables
variable "policy_name" {
   type = string
   default = "my_ec2_policy"
}

variable "role_name" {
   type = string
   default = "my_ec2_role"
}


variable "instance_profile_name" {
  type = string
  default   = "my_ec2_instance_profile"
}


#ec2_instance
variable "ami" {
   type = string
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "key_pair_nm" {
   type = string
}
