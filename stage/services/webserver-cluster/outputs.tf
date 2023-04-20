
output "database_dns_endpoint" {
  value = module.webserver_cluster.alb_dns_name 
  description = "Data base endpoint"
}

output "end_point_of_msql_database" {
    value = module.webserver_cluster.end_point_of_msql_database
    description = "End point of database server"
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
description = "The domain name of the load balancer"
}