resource "aws_db_subnet_group" "rds" {
  name       = "incode-rds-subnets"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "rds" {
  name   = "incode-rds-sg"
  vpc_id = var.vpc_id

  # Allow access from app subnet CIDR
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.app_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds" {
  identifier              = "incode-tennis-db"
  engine                  = "postgres"
  engine_version          = "18.1"
  instance_class          = var.db_instance_type
  allocated_storage       = 20
  username                = var.username
  password                = var.password
  db_name                 = "tennisdb"
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  skip_final_snapshot     = true
}
