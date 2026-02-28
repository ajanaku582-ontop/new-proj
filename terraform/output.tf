output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}

output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}