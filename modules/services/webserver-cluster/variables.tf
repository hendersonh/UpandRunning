variable "cluster_name" {
description = "The name to use for all the cluster resources"
type = string
}

variable "organization" {
description = "The name of the Organization"
type = string
}

variable "workspaces" {
description = "The name of the workspace"
type = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g.  t2.micro)"
  type = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type = number
}

variable "max_size" {
  description = "The maximun number of EC2 Instances in the ASG"
  type = number
}

variable "server_port" {
  description = "Server port to open"
  type = number
}