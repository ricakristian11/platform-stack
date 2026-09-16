output "alb_url" {
  value = "http://${aws_lb.main.dns_name}"
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.app.name
}
