variable "aws_access_key"{
    type = "string"
}
variable "aws_secret_key"{
    type ="string"
}
variable "aws_region"{
    type = "string"
}
variable "aws_ami_id_postgres1"{
    type = "string"
}
variable "aws_ami_id_postgres2"{
    type = "string"
}
variable "aws_inst_type_postgres1"{
    type = "string"
}
variable "aws_inst_type_postgres2"{
    type = "string"
}
variable "aws_subnet_postgres1"{
    type = "string"
}
variable "aws_subnet_postgres2"{
    type = "string"
}
variable "aws_inst_name_postgres1"{
    type= "string"
}
variable "aws_inst_name_postgres2"{
    type= "string"
}

variable "common_tags"{
	type="map"
}

variable "ec2_instance_tags"{
	type="map"
}

variable "ssh_security_group_tags" {
	type="map"
}

variable "postgres_security_group_tags" {
    type="map"
}

variable "postgres_alb_tags" {
    type="map"
}

variable "appname" {
	type="string"
}

variable "envname" {
    type="string"
}

variable "vpc_id" {
	type="string"
}

variable "securitygroup" {
	type="string"
}

variable "sg_ssh" {
	type = "string"
}

variable "sg_postgres" {
	type = "string"
}

variable desired_capacity {

}
variable max_size {

}
variable min_size {

}
variable postgres_target_group_port {
	type = "list"
}
variable postgres_target_group_protocol {
	type = "list"
}
variable tg_name {
	type = "string"
}
variable alb_postgres_name {
	type = "string"
}
variable postgres_certificate_arn {
	type = "string"
}

variable launch_config_image_id {
	type = "string"
}
variable launch_config_inst_type {
	type = "string"
}

variable asg_subnets {
	type = "list"
}
