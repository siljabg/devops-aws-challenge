variable "ami_id" {
  type        = string
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "subnet_id" {
  type        = string
  description = "Public subnet where instance will be launched"
}

variable "vpc_security_groups" {
  type        = list(string)
  description = "Security groups applied to EC2 instance"
}

variable "user_data" {
  type        = string
  description = "User data - application"
}
