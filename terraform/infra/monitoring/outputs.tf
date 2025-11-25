
output "ec2_alarm" { 
    value = aws_cloudwatch_metric_alarm.ec2_status.alarm_name 
}

output "rds_alarm" { 
    value = aws_cloudwatch_metric_alarm.rds_storage.alarm_name 
}

output "ec2_cpu_high_alarm" {
  value = aws_cloudwatch_metric_alarm.ec2_cpu_high.alarm_name
}

output "rds_cpu_high_alarm" {
  value = aws_cloudwatch_metric_alarm.rds_cpu_high.alarm_name
}

