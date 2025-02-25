# CloudWatch Monitoring
resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  alarm_name          = "EC2_High_CPU_Usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 60
  statistic          = "Average"
  threshold          = 80
  alarm_description  = "Triggers if EC2 CPU usage exceeds 80%"
  alarm_actions      = ["arn:aws:sns:us-east-1:123456789012:critical-alerts"]
}

resource "aws_cloudwatch_metric_alarm" "rds_high_latency" {
  alarm_name          = "RDS_High_Latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ReadLatency"
  namespace          = "AWS/RDS"
  period             = 60
  statistic          = "Average"
  threshold          = 100
  alarm_description  = "Triggers if RDS read latency exceeds 100ms"
  alarm_actions      = ["arn:aws:sns:us-east-1:123456789012:critical-alerts"]
}

resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "application-logs"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_metric_filter" "app_error_filter" {
  name           = "AppErrorFilter"
  log_group_name = aws_cloudwatch_log_group.application_logs.name

  pattern = "ERROR"

  metric_transformation {
    name      = "ErrorCount"
    namespace = "Application/Logs"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "app_error_alarm" {
  alarm_name          = "Application_Error_Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ErrorCount"
  namespace          = "Application/Logs"
  period             = 60
  statistic          = "Sum"
  threshold          = 5
  alarm_description  = "Triggers if more than 5 errors occur in application logs"
  alarm_actions      = ["arn:aws:sns:us-east-1:123456789012:critical-alerts"]
}
