resource "aws_iam_role" "lambda_role" {
  name = "lambda_ec2_management_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    purpose = "managing_ec2_lambda_python_functions"
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "lambda_ec2_management_policy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CloudWatchLogsPermissions",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Sid": "DescribeEC2Instances",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Resource": "*"
    },
    {
      "Sid": "StartStopEC2Instances",
      "Effect": "Allow",
      "Action": [
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      "Resource": "arn:aws:ec2:*:*:instance/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "lambda_role-policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


resource "aws_iam_role" "event_bridge_role" {
  name = "event_bridge_lamba_trigger_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy" "scheduler_lambda_policy" {
  name = "scheduler_lambda_invoke_policy"
  role = aws_iam_role.event_bridge_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = [
          aws_lambda_function.start_instances.arn,
          aws_lambda_function.stop_instances.arn
        ]
      }
    ]
  })
}