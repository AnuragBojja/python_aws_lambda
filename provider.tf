terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket       = "lambda-ec2-manage-bucket"
    key          = "remote-state-python-ec2-managemnt-lambda"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

