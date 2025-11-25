data "aws_ami" "al2023" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }
}

module "vpc" {
  source          = "./vpc"
  cidr            = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
}

module "rds" {
  source             = "./rds"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_instance_type   = var.db_instance_type
  username           = var.db_username
  password           = local.db_password
  app_cidr           = "10.0.1.0/24"
}

module "ec2" {
  source              = "./ec2"
  subnet_id           = module.vpc.public_subnets[0]
  vpc_security_groups = [module.vpc.ec2_sg]
  instance_type       = var.instance_type
  user_data           = local.user_data
  ami_id              = data.aws_ami.al2023.id
}

module "monitoring" {
  source          = "./monitoring"
  ec2_instance_id = module.ec2.app_instance_id
  rds_identifier  = module.rds.db_identifier
}
