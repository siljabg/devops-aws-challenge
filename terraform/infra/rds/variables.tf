variable "vpc_id" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "username" {
  type = string
}

variable "password" {
  type = string
  sensitive = true
}
variable "app_cidr" {
  description = "CIDR from which app can access RDS"
  type        = string
}
variable "db_instance_type" {
  description = "db instance type"
  type        = string
}
