
module "webserver_cluster" "web_server" {
    source = "../../../modules/services/webserver-cluster"

    organization = "hendy"
    workspaces = "mysql"

    instance_type = "t2.micro"
    min_size      = 2
    max_size      = 2
}