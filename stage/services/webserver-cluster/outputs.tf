
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