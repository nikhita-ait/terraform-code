provider "aws" {
  region = "us-east-1"
}


#Module : VPC

resource "aws_vpc" "vpc_main"{
   cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
   vpc_id = aws_vpc.vpc_main.id
   cidr_block = var.public_cidr
   map_public_ip_on_launch = true
} 

resource "aws_subnet" "private" {
   vpc_id = aws_vpc.vpc_main.id
   cidr_block = var.private_cidr
} 

resource "aws_internet_gateway" "public_ig" {
    vpc_id = aws_vpc.vpc_main.id
}

resource "aws_route_table"  "public_rt"{
    vpc_id = aws_vpc.vpc_main.id
    route{
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.public_ig.id
   }
}

resource "aws_route_table_association" "public_rt_assoc" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_gw_eip" {
   domain = "vpc"
}

resource "aws_nat_gateway" "private_nat_ig" {
     allocation_id = aws_eip.nat_gw_eip.id
     subnet_id = aws_subnet.private.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_main.id
  route {
     cidr_block =  "0.0.0.0/0"
     nat_gateway_id = aws_nat_gateway.private_nat_ig.id
 }
}

resource "aws_route_table_association" "private_rt_assoc"{
           subnet_id = aws_subnet.private.id
           route_table_id = aws_route_table.private_rt.id
}

#Module : Security Group
#bastion_host_web
resource "aws_security_group" "ec2_instance-bastionhost" {
       vpc_id = aws_vpc.vpc_main.id
      ingress {
         from_port = 22
         to_port = 22
         protocol = "tcp"
         cidr_blocks = [var.public_cidr]
     }
      ingress {
         from_port = 80
         to_port = 80 
         protocol = "tcp"
         cidr_blocks = [var.public_cidr]
      }
      egress {
         from_port = 0
         to_port = 0
         protocol = "-1"
         cidr_blocks = [var.public_cidr]
     }
}
#bastion_host_db
resource "aws_security_group" "rds_sg" {
    vpc_id = aws_vpc.vpc_main.id
    ingress {
     from_port = 3309
     to_port = 3309
     protocol =  "tcp"
     cidr_blocks = [var.private_cidr]
     }
     egress { 
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
     }
}

#Module : RDS Db instance

resource "aws_db_instance" "rds_db" {
   identifier = var.identifier
   allocated_storage = var.allocated_storage
   instance_class = var. instance_class
   engine = var.engine
   db_name = var.db_name
   username = var.username
   password = var.password
   parameter_group_name = var.parameter_group_name
   skip_final_snapshot = var.skip_final_snapshot
   vpc_security_group_ids = var.vpc_security_group_ids
   db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
 }

resource "aws_db_subnet_group" "rds_subnet_group" {
   subnet_ids = [ var.private_subnet_id ]
}

#Module : IAM 

resource "aws_iam_role" "my_role" {
   name = var.policy_name
   assume_role_policy = jsonencode({
           Version = "2012-10-17"
           Statement = [{
              Action = "sts:AssumeRole"
              Effect = "Allow"
              Principal = {
                   Service = "ec2.amazonaws.com"
              }},
             ]
           })
}

resource "aws_iam_role_policy" "my_policy" {
    role = aws_iam_role.my_role.id
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_policy" "my_policy" {
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "kms:Decrypt"
        ]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment"  "my_attach_policy"{
     role = aws_iam_role.my_role.name
     policy_arn = aws_iam_policy.my_policy.arn
}

resource "aws_iam_instance_profile" "test_profile" {
       name = var.instance_profile_name
       role = aws_iam_role.my_role.name
}

#Module : Secret Manger

resource "aws_kms_key" "my_kms_key" {
    enable_key_rotation = true
    deletion_window_in_days = 7
}

resource "aws_secretsmanager_secret" "rds_credentials" {
    kms_key_id = aws_kms_key.my_kms_key.key_id
}

resource "aws_secretsmanager_secret_version" "rds_cred_value" {
   secret_id = aws_secretsmanager_secret.rds_credentials.id
   secret_string = jsonencode ({ 
      username = var.username
      password = var.password
    })
}

#Module - EC2 instance
resource "aws_instance" "my-ec2" {
    ami = var.ami
    instance_type = var.instance_type
    iam_instance_profile = var.instance_profile_name
    key_name  = var.key_pair_nm
    subnet_id = var.public_subnet_id
    vpc_security_group_ids = var.vpc_security_group_ids
    user_data  = <<-E0F
      apt-get update -y
      apt-get install -y docker-ce docker-ce-cli containerd.io

      systemctl enable docker
      systemctl start docker

      usermod -aG docker ubuntu
      systemctl status docker
      E0F
}

#Moodule - Bastion instance
resource "aws_instance" "bastion-host" {
   ami = var.ami
   instance_type = var.instance_type
   iam_instance_profile = var.instance_profile_name
   key_name  = var.key_pair_nm
   subnet_id = var.public_subnet_id
   vpc_security_group_ids = var.vpc_security_group_ids
}

