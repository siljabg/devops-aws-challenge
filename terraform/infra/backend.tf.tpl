terraform {
  backend "s3" {
    bucket         = "${bucket_name}"
    key            = "backend/terraform.tfstate"
    region         = "${region}"
    dynamodb_table = "${lock_table_name}"
    encrypt        = true
  }
}
