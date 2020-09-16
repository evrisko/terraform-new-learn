provider "aws" {
  region = "eu-central-1"
}

# Create instance
resource "aws_instance" "my_webserver" {
  ami                    = "ami-08c148bb835696b45" # Amazon Linux 2 ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  depends_on             = [aws_instance.my_database, aws_instance.my_application]
  tags = {
    Name = "Amazon Linux 2 Webserver"
  }
}
resource "aws_instance" "my_application" {
  ami                    = "ami-08c148bb835696b45" # Amazon Linux 2 ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  depends_on             = [aws_instance.my_database]
  tags = {
    Name = "Amazon Linux 2 Webserver"
  }
}
resource "aws_instance" "my_database" {
  ami                    = "ami-08c148bb835696b45" # Amazon Linux 2 ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  tags = {
    Name = "Amazon Linux 2 Webserver"
  }
}

# Create Security Group
resource "aws_security_group" "my_webserver" {
  name        = "Webserver Security Group"
  description = "Allow HTTP HTTPS"
  tags = {
    Name  = "Dynamic Security Group Webserver"
    Build = "Terraform"
  }
  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
