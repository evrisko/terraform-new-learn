provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "current" {}
data "aws_vpc" "my_vpc" {
  tags = {
    Name = "prod"
  }
}
data "aws_subnet" "selected" {
  tags = {
    Name = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
  }
}

resource "aws_subnet" "prod_subnet_1" {
  vpc_id            = data.aws_vpc.my_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.0.0.0/24"
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}
resource "aws_subnet" "prod_subnet_2" {
  vpc_id            = data.aws_vpc.my_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name    = "Subnet-2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}

output "data_aws_availability_zone_name" {
  value = data.aws_availability_zones.working.names[1]
}
output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}
output "data_aws_region_name" {
  value = data.aws_region.current.name
}
output "data_aws_region_description" {
  value = data.aws_region.current.description
}
output "aws_vpc_ids" {
  value = data.aws_vpcs.current.ids
}
output "prod_vpc_id" {
  value = data.aws_vpc.my_vpc.id
}
output "prod_vpc_cidr" {
  value = data.aws_vpc.my_vpc.cidr_block
}
output "prod_subnet_1" {
  value = data.aws_subnet.selected.cidr_block
}
