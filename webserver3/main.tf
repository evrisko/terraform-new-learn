#green-blue deployment
#Zero down time
#test
provider "aws" {}

data "aws_availability_zones" "available" {}
data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "Webserver Security Group"
  description = "Allow HTTP HTTPS"
  tags = {
    Name  = "Dynamic Security Group Webserver 3"
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

resource "aws_launch_configuration" "web" {
  name_prefix     = "lc-web-"
  image_id        = data.aws_ami.amazon_linux_2.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.my_webserver.id]
  user_data       = file("user_data.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name                 = "asg-web-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.web.name]
  #dymamic tags
  dynamic "tag" {
    for_each = {
      Name  = "Web ASG Server"
      Owner = "Oleg Boslovyak"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }

  }

  /* static tags
  tags = [
    {
      key                 = "Name"
      value               = "Webserver"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "Oleg Boslovyak"
      propagate_at_launch = true
    },
  ]
*/

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name               = "elb-web"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.my_webserver.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "elb-web"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

output "web_loadbalancer_domain_name" {
  value = aws_elb.web.dns_name
}
