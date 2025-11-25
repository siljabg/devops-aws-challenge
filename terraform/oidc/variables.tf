variable "aws_region" {
  type = string
}

variable "github_repo" {
  description = "GitHub repo in the form owner/repo"
  type        = string
}

variable "bucket_name" {
  description = "Terraform state s3 bucket name"
  type        = string
}

variable "lock_table_name" {
  type = string
}