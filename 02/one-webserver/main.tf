# 단일 웹 서버 배포
#
# provider
#
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.25.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  profile = "myAWS"
}


#
# resource
#
resource "aws_instance" "myinstance" {
  ami                    = "ami-0f5fcdfbd140e4ab7"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_8080.id]

  user_data = <<-EOF
        #!/bin/bash
        echo 'Hello World' > index.html
        nohup busybox httpd -f -p 8080 &
        EOF

  user_data_replace_on_change = true

  tags = {
    Name = "My First Instnace"
  }
}

resource "aws_security_group" "allow_8080" {
  name        = "allow_8080"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "allow_8080"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_8080_http" {
  security_group_id = aws_security_group.allow_8080.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_8080.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}