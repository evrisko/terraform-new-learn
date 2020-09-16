provider "aws" {
  region = "eu-central-1"
}

#Create static IP
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
  tags = {
    Name = "Webserver Static IP"
  }
}

# Create instance
resource "aws_instance" "my_webserver" {
  ami                    = "ami-08c148bb835696b45" # Amazon Linux ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    first_name = "Oleg",
    last_name  = "Boslovyak",
    clubs      = ["Arsenal", "Liverpool", "Tottenham", "Chealsea", "Lester", "Manchester", "Sheffild"]
  })
  tags = {
    Name = "Amazon Linux 2 Webserver"
  }
  lifecycle {
    create_before_destroy = true
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
    for_each = ["80", "443"]
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

#terraform show
#terraform output
