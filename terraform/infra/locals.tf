data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
  depends_on = [
    aws_secretsmanager_secret_version.db_password_value
  ]
}

locals {
  db_password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string).password

  user_data = templatefile("${path.module}/user_data.sh", {
    DB_ENDPOINT = module.rds.endpoint
    DB_USER     = var.db_username
    DB_PASS     = local.db_password
    DB_NAME     = "tennisdb"
  })
}
