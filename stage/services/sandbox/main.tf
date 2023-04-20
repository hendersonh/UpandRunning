
resource "aws_key_pair" "upandrunning-key" { 
    key_name = "upandrunning"
    public_key = file("${path.module}/upandrunning.pub") # ssh-keygen -t ed25519
}
    
# Security Group for the sandbox 
resource "aws_security_group" "sandbox" {
    name_prefix =   "sandbox-"

    ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    from_port = 22 
    to_port = 22 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "sandbox"{
    ami = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    vpc_security_group_ids =  [aws_security_group.sandbox.id]
    key_name = "upandrunning"

    # Render the User Data script as a template 
    user_data = templatefile("user-data.tftpl", {
        server_port = var.server_port
        db_address = var.db_port 
        db_port = var.db_address 
    })

    tags = {
        Name = "sandbox"
    } 
}



