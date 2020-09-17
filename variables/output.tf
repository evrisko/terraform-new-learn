output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
}
output "webserver_public_ip_address" {
  value = aws_eip.my_static_ip.public_ip
}
output "security_group_id" {
  value = aws_security_group.my_webserver.id
}
