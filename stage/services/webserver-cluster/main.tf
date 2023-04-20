
module "webserver_cluster"  {
    source = "../../../modules/services/webserver-cluster"

    organization = "hendy"
    workspaces = "mysql"
    cluster_name = "web-server-cluster"
    instance_type = "t2.micro"
    min_size      = 2
    max_size      = 2
    server_port   = 80
}

# Altering the webcluster module to temporarily allow incoming on additionl ports
resource "aws_security_group_rule" "allow_testing_inbound" {
    type = "ingress"
    security_group_id = module.webserver_cluster.id_of_sg_for_instance
    
    from_port = 12345
    to_port = 12345
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}