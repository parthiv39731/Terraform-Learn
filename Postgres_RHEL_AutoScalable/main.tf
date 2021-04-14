#------------------------------------------------------------------------------------------------------------------------------------------
#Description: This script is used to create Autoscalable Postgres Instance in aws RHEL
#  Load Balancer
#  2 DB server Postgres (EC2) servers
#usage: Intializing a new Terraform template --> terraform init
#       Customising deploument with variables --> terraform plan     OR         --> terraform plan -var="variable=value" (for including variables straight from the command line)
#       plan,apply or destroy                --> terraform apply      OR    --> terraform apply value (if we have stored  for any output value )
#output: Create Autoscalable Postgres Instances in aws RHEL 
#Owner: iAutomate Team
#tester: iAutomate Team
#---------------------------------------------------------------------------------------------------------------------------------------------
#Define the Provider
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

#creating aws security group
resource "aws_security_group" "sg_allow_ssh" {
  count       = "${var.securitygroup == "" ? 1 : 0}"
  name        = "${var.sg_ssh}_${var.vpc_id}_${var.appname}_${var.envname}"
  description = "allow connection from ssh"
  vpc_id      = var.vpc_id
  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  tags = merge(var.common_tags, var.ssh_security_group_tags)
}

resource "aws_security_group" "sg_allow_postgres" {
  count       = var.securitygroup == "" ? 1 : 0
  name        = "${var.sg_postgres}_${var.vpc_id}_${var.appname}_${var.envname}"
  description = "allow postgres on port 5432"
  vpc_id      = var.vpc_id
  ingress {
    description = "allow postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  }
  tags = merge(var.common_tags, var.postgres_security_group_tags)
}

#creating aws security group to allow HTTP/HTTPS on port 8080/443
resource "aws_security_group" "sg_allow_http_https" {
  count       = var.securitygroup == "" ? 1 : 0
  name        = "sg_http_https_${var.vpc_id}_${var.appname}_${var.envname}"
  description = "Allow HTTP/HTTPS on Port 8080,443"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow HTTP on Port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }
  ingress {
    description = "Allow HTTPS on Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  tags = merge(var.common_tags, var.postgres_security_group_tags)
}

#creating load balancer for Postgres1,Postgres2
resource "aws_lb" "alb_postgres" {
  name               = "${var.alb_postgres_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.sg_allow_http_https[0].id,
  ]
  subnets = var.asg_subnets
  tags    = merge(var.common_tags, var.postgres_alb_tags)
}

#creating target group on which to receive traffic
resource "aws_lb_target_group" "postgres_target_group_http" {
  port     = var.postgres_target_group_port[0]
  protocol = var.postgres_target_group_protocol[0]
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "postgres_target_group_https" {
  port     = var.postgres_target_group_port[0]
  protocol = var.postgres_target_group_protocol[1]
  vpc_id   = var.vpc_id
}

#Create AutoScaling Group for Postgres1,2
resource "aws_autoscaling_group" "postgres_asg" {
  desired_capacity     = "${var.desired_capacity}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  vpc_zone_identifier  = var.asg_subnets
  launch_configuration = aws_launch_configuration.postgres_lc.name
}

#Create AutoScaling Group Attachment for Postgres1,2
resource "aws_autoscaling_attachment" "asg_attachment_postgres_tg_http" {
  autoscaling_group_name = aws_autoscaling_group.postgres_asg.id
  alb_target_group_arn   = aws_lb_target_group.postgres_target_group_http.arn
}

resource "aws_autoscaling_attachment" "asg_attachment_postgres_tg_https" {
  autoscaling_group_name = aws_autoscaling_group.postgres_asg.id
  #elb                    = aws_lb.alb_postgres.id
  alb_target_group_arn = aws_lb_target_group.postgres_target_group_https.arn
}

resource "aws_launch_configuration" "postgres_lc" {
  name_prefix   = "postgres-as-"
  image_id      = "${var.launch_config_image_id}"
  instance_type = "${var.launch_config_inst_type}"
  security_groups = [
    aws_security_group.sg_allow_ssh[0].id,
    aws_security_group.sg_allow_postgres[0].id,
  ]
  user_data = <<-eof
              #!bin/bash
              sudo yum install -y postgresql-server postgresql-contrib && sudo postgresql-setup initdb && sudo systemctl start postgresql && sudo systemctl enable postgresql && sudo passwd postgres
              eof
  provisioner "local-exec" {
    command = "terraform show -json > completed.txt"
  }
}
