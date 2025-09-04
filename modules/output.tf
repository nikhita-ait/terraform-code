output "vpc_id" {
  value =  aws_vpc.vpc_main.id
}
 
output "public_subnet_id" {
  value =  aws_subnet.public_subnet.id
}
 
output "private_subnet_ids" {
value =  [ aws_subnet.private_subnet_a.id , aws_subnet.private_subnet_b.id ]
}
 
#sg-rules
output "ec2_bation_sg_id"{
   value = aws_security_group.ec2_instance_bastionhost.id
}

output "rds_sg_id" {
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
output "secret_manager_secret_arn" {
  value = aws_secretsmanager_secret.rds_credentials.arn
} 

