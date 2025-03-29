terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# create security group for the ec2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2 security group"
  description = "allow access on ports 22"

  # allow access on port 22
  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh access"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Monitoring server security group"
  }
}

resource "aws_instance" "Monitoring_server" {
ami = "ami-084568db4383264d4"  
instance_type = "t2.medium"
security_groups = [aws_security_group.ec2_security_group.name]
key_name = var.key_name

user_data = templatefile("./installation.sh", {})

tags = {
  Name: var.instance_name
}

root_block_device {
  volume_size = 30
  delete_on_termination = true
}
}
