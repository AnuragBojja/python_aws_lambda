resource "aws_scheduler_schedule" "start_ec2" {
  name                         = "start_ec2"
  schedule_expression          = "cron(30 13 * * ? *)"
  schedule_expression_timezone = "America/Chicago"
  flexible_time_window {
    mode = "OFF"
  }
  target {
    arn      = aws_lambda_function.start_instances.arn
    role_arn = aws_iam_role.event_bridge_role.arn
  }
  depends_on = [aws_iam_role_policy.scheduler_lambda_policy]
}

resource "aws_scheduler_schedule" "stop_ec2" {
  name                         = "stop_ec2"
  schedule_expression          = "cron(25 13 * * ? *)"
  schedule_expression_timezone = "America/Chicago"
  flexible_time_window {
    mode = "OFF"
  }
  target {
    arn      = aws_lambda_function.stop_instances.arn
    role_arn = aws_iam_role.event_bridge_role.arn
  }
  depends_on = [aws_iam_role_policy.scheduler_lambda_policy]
}