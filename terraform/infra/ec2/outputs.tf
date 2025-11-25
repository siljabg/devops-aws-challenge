output "public_ip" {
  value = aws_instance.app.public_ip
}

output "private_ip" {
  value = aws_instance.app.private_ip
}

output "app_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app.id
}
