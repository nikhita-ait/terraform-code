

#VPC
vpc_cidr = "10.0.0.0/16" 
public_cidr = "10.0.1.0/24"
private_cidr_a = "10.0.2.0/24"
private_cidr_b = "10.0.3.0/24"
azs = ["us-east-1a", "us-east-1b"]
subnet_id = null
#Scurity-Group


#rds
identifier = "my-rds"
db_name = "GPODS03"
username = "admin"
password = "MyStrongPass123"

#ec2-instancengine 
key_pair_nm = "taerraform-demo-codespace"
ami = "ami-0360c520857e3138f"
instance_type  = "t2.micro"
