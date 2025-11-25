variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "bucket_name" {
  type = string
}

variable "lock_table_name" {
  type = string
}

variable "oidc_role_arn" {
  type = string
}

variable "project_name" {
  type    = string
  default = "incode-devops-aws-challenge"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "db_instance_type" {
  type    = string
  default = "db.t3.micro"
}

variable "db_username" {
  type    = string
  default = "tennisadmin"
}

variable "owner_name" {
  type    = string
  default = "Dragan Siljanovski"
}