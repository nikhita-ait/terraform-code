output "vpc_id" {
  value =  aws_vpc.vpc_main.id
}
 
output "public_subnet_id" {
  value =  aws_subnet.public.id
}
 
output "private_subnet_id" {
value =  aws_subnet.private.id
}
 
#sg-rules
output "ec2-bation-sg-id"{
   value = aws_security_group.ec2_instance-bastionhost.id
}

output "rds-sg-id" {
   value = aws_security_group.rds_sg.id
}

#rds_db
output "rds_port" {
  value = aws_db_instance.rds_db.port

}

#iam-role
output "instance_profile_name" {
  value = aws_iam_instance_profile.test_profile.name
}

#secret-manager
output "secret-manager_secret_arn {
  value = aws_secretsmanager_secets.rds_credentials.arn
} 

