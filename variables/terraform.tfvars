#auto fill parameters. It has priority
# terraform.tfvars
# *.auto.tfvars
region                     = "ca-central-1"
instance_type              = "t2.micro"
enable_detailed_monitoring = "false"
common_tags = {
  Owner       = "Oleg Boslovyak"
  Project     = "Terraform"
  Environment = "Stage"
  Bill        = "123123123"
}
