# name output can be any
output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
}
output "webserver_public_ip_address" {
  value = aws_eip.my_static_ip.public_ip
}
output "webserver_public_domain_name" {
  value       = aws_eip.my_static_ip.public_dns
  description = "Public Domain name for Webserver"
}
output "webserver_security_group_name_id" {
  value = aws_security_group.my_webserver.id
}
output "webserver_security_group_arn" {
  value = aws_security_group.my_webserver.arn
}
