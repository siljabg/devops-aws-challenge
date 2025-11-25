output "endpoint" {
  value = aws_db_instance.rds.address
}

output "db_identifier" {
  value = aws_db_instance.rds.id
}
