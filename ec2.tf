resource "aws_spot_instance_request" "spot" {
  count                  = 2
  ami                    = data.aws_ami.roboshop_ami.id
  vpc_security_group_ids = [aws_security_group.spot.id]
  instance_type          = var.instance_type
  spot_type              = "persistent"
  wait_for_fulfillment   = true
  tags = {
    "Name" = "workstation",
    "env"  = "dev"
  }
}

resource "aws_ec2_tag" "spot_name" {
  count       = length(aws_spot_instance_request.spot)
  resource_id = aws_spot_instance_request.spot[count.index].spot_instance_id
  key         = "Name"
  value       = "workstation"
}

resource "aws_ec2_tag" "spot_env" {
  count       = length(aws_spot_instance_request.spot)
  resource_id = aws_spot_instance_request.spot[count.index].spot_instance_id
  key         = "env"
  value       = "dev"
}

resource "aws_ec2_tag" "spot_schudule" {
  count       = length(aws_spot_instance_request.spot)
  resource_id = aws_spot_instance_request.spot[count.index].spot_instance_id
  key         = "schedule_to_stop"
  value       = "true"
}


resource "aws_security_group" "spot" {
  name        = "spot_instances_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  tags = {
    Name = "spot_instances_sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "jenkins" {
  security_group_id = aws_security_group.spot.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins" {
  security_group_id = aws_security_group.spot.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}