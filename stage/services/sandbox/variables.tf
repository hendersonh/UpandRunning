

variable "server_port" {
description = "The port the server will use for HTTP requests"
type = number
default = 80
}

variable "db_address" {
description = "DB endpoint"
type = string 
default = "db.hendersonhood.com"
}

variable "db_port" {
description = "The DB connection Port"
type = number
default = 80
}