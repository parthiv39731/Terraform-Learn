aws_access_key = "XXXXXXXXXXXXXXXXXXXXXXXXXX"
aws_secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXX"
aws_region = "us-east-1"
aws_ami_id_postgres1 = "ami-0394fe9914b475c53"
aws_ami_id_postgres2 = "ami-0394fe9914b475c53"
aws_inst_type_postgres1 = "t2.micro"
aws_inst_type_postgres2 = "t2.micro"
aws_subnet_postgres1 = "subnet-42b78736"
aws_subnet_postgres2 = "subnet-801263a8"
aws_inst_name_postgres1 = "postgres_rhel_as1"
aws_inst_name_postgres2 = "postgres_rhel_as2"
vpc_id = "vpc-c09e89a2" #"vpc-0914b36d" #"vpc-0486380729bd93b4d"
appname = "postgres_as"
envname = "rhel"
securitygroup = ""
common_tags = {
 "instance_name_postgres1" = "postgres_rhel_as1"
 "instance_name_postgres2" = "postgres_rhel_as2"
 "test" = "test"
}
ec2_instance_tags = {
 "test" = "test"
}
ssh_security_group_tags = {
 "test" = "test" 
}
postgres_security_group_tags = {
 "test" = "test"
}
postgres_alb_tags = {
 "test" = "test"
}
sg_ssh = "sg_ssh"
sg_postgres = "sg_postgres"
desired_capacity = 2
max_size = 5
min_size = 1
postgres_target_group_port = [5432]
postgres_target_group_protocol = ["HTTP","HTTPS"]
tg_name = "tg-postgres-as"
alb_postgres_name = "alb-postgres-as"
postgres_certificate_arn = "arn:aws:iam::250115977078:server-certificate/iimss_test"
launch_config_image_id = "ami-0394fe9914b475c53"
launch_config_inst_type = "t2.micro"
asg_subnets = ["subnet-42b78736", "subnet-801263a8"]