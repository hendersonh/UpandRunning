terraform {
  backend "remote" {
    organization = "hendy"

    workspaces {
      name = "Web-cluster"
    }
  }
}

provider "aws" {
region = "us-east-2"
}

resource "aws_key_pair" "upandrunning-key" { 
    key_name = "upandrunning"
    public_key = file("${path.module}/upandrunning.pub") # ssh-keygen -t ed25519
}
    
# Security Group for the Instances
resource "aws_security_group" "instance" {
    name_prefix =   "upandrunning-instance"

    ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    from_port = 20 
    to_port = 29 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_launch_configuration" "example" {
    name_prefix = "UpandRunning"
    image_id = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.instance.id]
    key_name =  "upandrunning" 
    
    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, World" > index.html
        nohup busybox httpd -f -p ${var.server_port} &
        EOF

    # Regquired when using a Lunch configuration with an auto scaling group
    lifecycle {
      create_before_destroy = true 
    }

    depends_on = [
      aws_key_pair.upandrunning-key   
    ]
}


#lookup data for default vpc
data "aws_vpc" "default" {
    default = true
}

#get all subnets IDs in the default vcp
data "aws_subnets" "default" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}


#create auto scaling group : ASG
resource "aws_autoscaling_group" "example" {
    name = "UpandRunning-asg-example"
    launch_configuration = aws_launch_configuration.example.name
    vpc_zone_identifier = data.aws_subnets.default.ids
    
    target_group_arns = [aws_lb_target_group.asg.arn]
    health_check_type = "ELB"

    min_size = 2
    max_size = 10

    lifecycle {
      create_before_destroy = true
    }

    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
    }
}

#create a Load balancer
resource "aws_lb" "example" {
    name = "terraform-asg-example"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.alb.id]
}

#load balancer will need a Listener
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.example.arn
    port = var.server_port 
    protocol = "HTTP"
   
    # By default, return a simple 404 page
    default_action {
        type = "fixed-response"
    
        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = 404
        }
    }
}

#need a security group for ALB
resource "aws_security_group" "alb" {
    name = "terraform-example-alb"

    # Allow inbound HTTP requests
    ingress {
        from_port = var.server_port 
        to_port = var.server_port 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all outbound requests
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
      create_before_destroy = true 
    }
}

#ALG needs a Target group
resource "aws_lb_target_group" "asg" {
    name = "terraform-asg-example"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
    }

    
}

# We will need listener rules for the ALB
resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100

    condition {
        path_pattern {
            values = ["*"]
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.asg.arn
    }
}

# get database connection info.
data "terraform_remote_state" "mysql" {
    backend = "remote"

    config = {
        organization = "hendy"
        workspaces = {
            name = "mysql"
        }
    }
}

output "remote_mysql_state" {
    value = "data.terraform_remote_state.mysql"
}
    
