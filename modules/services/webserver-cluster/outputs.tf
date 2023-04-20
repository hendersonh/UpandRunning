
output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

output "end_point_of_msql_database" {
    value = data.terraform_remote_state.mysql.outputs.address
    description = "End point of database server"
}

output "data-base-port-number" {
    value = data.terraform_remote_state.mysql.outputs.port
    description = "Database port number"
}

output "asg_name" {
  value = aws_autoscaling_group.example.name
description = "The name of the Auto Scaling Group"
}

#exporting the Instance security group to allow external modifications
output "id_of_sg_for_instance"  {
  value       = aws_security_group.instance.id 
  description = "The ID of the Instance Security Group"
} 

#exporting the alb security group to allow external modifications
output "id_of_sg_for_alb"  {
  value       =  aws_security_group.alb.id
  description = "The ID of the ALB Security Group"
} 