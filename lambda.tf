data "archive_file" "start_instances_zip" {
  type        = "zip"
  source_file = "${path.module}/scripts/start_instances.py"
  output_path = "${path.module}/start_instances.zip"
}
data "archive_file" "stop_instances_zip" {
  type        = "zip"
  source_file = "${path.module}/scripts/stop_instances.py"
  output_path = "${path.module}/stop_instances.zip"
}


resource "aws_lambda_function" "start_instances" {
  filename      = data.archive_file.start_instances_zip.output_path
  function_name = "start_instance_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "start_instances.lambda_handler"
  code_sha256   = data.archive_file.start_instances_zip.output_base64sha256
  timeout       = 60

  runtime = "python3.11"

  tags = {
    Environment = "dev"
    Application = "lambda_start"
  }

  depends_on = [aws_iam_policy.lambda_policy]
}

resource "aws_lambda_function" "stop_instances" {
  filename      = data.archive_file.stop_instances_zip.output_path
  function_name = "stop_instance_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "stop_instances.lambda_handler"
  code_sha256   = data.archive_file.stop_instances_zip.output_base64sha256
  timeout       = 60

  runtime = "python3.11"

  tags = {
    Environment = "dev"
    Application = "lambda_stop"
  }

  depends_on = [aws_iam_policy.lambda_policy]
}