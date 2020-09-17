
provider "aws" {
  region = var.region
}

data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]} Server IP"
  })
}

resource "aws_instance" "my_webserver" {
  ami                    = data.aws_ami.amazon_linux_2.id # Amazon Linux ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  monitoring             = var.detail_monitoring
  #  tags                   = var.common_tags
  tags = merge(var.common_tags, {
    Name = "Amazon Linux 2 Webserver"
  })
  /*  tags = {
    Name    = "Amazon Linux 2 Webserver"
    Owner   = "Oleg Boslovyak"
    Project = "Terraform"
  }
  */
}

resource "aws_security_group" "my_webserver" {
  name        = "Webserver Security Group"
  description = "Allow HTTP HTTPS"
  #  tags        = var.common_tags
  tags = merge(var.common_tags, {
    Name = "Dynamic Security Group Webserver"
  })
  dynamic "ingress" {
    for_each = var.allow_ports
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
