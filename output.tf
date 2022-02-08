output "ip_wordpress" {
  value = aws_instance.wp-ins.public_ip
}

output "ip_mysql" {
  value = aws_instance.mysql-ins.private_ip
}