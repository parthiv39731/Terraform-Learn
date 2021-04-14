#----------------------------------------OUTPUTS------------------------------------------




#-----------------------------------------------------------------------------------------

 output "SG_ALLOW_SSH" {
   value = aws_security_group.sg_allow_ssh[0].id
 }

 output "SG_ALLOW_POSTGRES" {
   value = aws_security_group.sg_allow_postgres[0].id
 }

 output "SSH_VPC_ID" {
   value = aws_security_group.sg_allow_ssh[0].vpc_id
 }

 output "POSTGRES_VPC_ID" {
   value = aws_security_group.sg_allow_postgres[0].vpc_id
 }

 output "LAUNCH_CONFIG_NAME" {
   value = aws_launch_configuration.postgres_lc.name
 }

 output "LAUNCH_CONFIG_ID" {
   value = aws_launch_configuration.postgres_lc.id
 }
 
 
#-------------
