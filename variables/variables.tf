variable "region" {
  description = "Please enter AWS region"
  type        = string #this is default type if not existing
  default     = "ca-central-1"
}
variable "instance_type" {
  description = "Enter instance type"
  default     = "t3.micro"
}
variable "allow_ports" {
  description = "List of ports to open"
  type        = list
  default     = ["80", "443", "22"]
}
variable "detail_monitoring" {
  type    = bool
  default = "false"
}
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map
  default = {
    Owner       = "Oleg Boslovyak"
    Project     = "Terraform"
    Environment = "Development"
  }
}
