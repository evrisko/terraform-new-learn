provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-08c148bb835696b45" # Amazon Linux ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    first_name = "Oleg",
    last_name  = "Boslovyak",
    clubs      = ["Arsenal", "Liverpool", "Tottenham", "Chealsea"]
  })
  tags = {
    Name = "Amazon Linux 2 Webserver"
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "Webserver Security Group"
  description = "Allow HTTP HTTPS"
  tags = {
    Name  = "Security Group Webserver"
    Build = "Terraform"
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
