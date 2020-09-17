# Search the latest AMI
provider "aws" {}

data "aws_ami" "ubuntu_2004" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
data "aws_ami" "windows_2019" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}
output "latest_ubuntu_ami_id" {
  value = data.aws_ami.ubuntu_2004.id
}
output "latest_ubuntu_ami_name" {
  value = data.aws_ami.ubuntu_2004.name
}
output "latest_amazon_linux2_ami_id" {
  value = data.aws_ami.amazon_linux_2.id
}
output "latest_amazon_linux2_ami_name" {
  value = data.aws_ami.amazon_linux_2.name
}
output "latest_windows_server_2019_ami_id" {
  value = data.aws_ami.windows_2019.id
}
output "latest_windows_server_2019_ami_name" {
  value = data.aws_ami.windows_2019.name
}
