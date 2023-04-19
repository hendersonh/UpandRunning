
output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

output "mysql_endpoint" {
  value = data.terraform_remote_state.mysql.address
  description = "The end point of the mysql database"
}
    
output "mysql_port" {
  value = data.terraform_remote_state.mysql.port
  description = "The port number of the mysql database"
}