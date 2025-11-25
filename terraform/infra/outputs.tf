output "app_public_ip" {
  value = module.ec2.public_ip
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "ec2_alarm" {
  value = module.monitoring.ec2_alarm
}

output "rds_alarm" {
  value = module.monitoring.rds_alarm
}

output "ec2_cpu_high_alarm" {
  value = module.monitoring.ec2_cpu_high_alarm
}

output "rds_cpu_high_alarm" {
  value = module.monitoring.rds_cpu_high_alarm
}