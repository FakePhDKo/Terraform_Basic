########################
# Provider 설정
########################
provider "aws" {
    region = "us-east-2"
    profile = "myAWS"
}

########################
# Resource 설정
########################
# AMI ID 찾기
# Data Source: aws_ami
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# SG 및 inbound/outbound rule 생성
# Resource: aws_security_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "Allow 22/tcp inbound traffic and all outbound traffic"

  tags = {
    Name = "mysg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# EC2 생성
# Resource: aws_instance
# * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "myweb" {
  # AMI: Ubuntu 24.04 LTS
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "mykeypair"
  vpc_security_group_ids = [aws_security_group.mysg.id]

  tags = {
    Name = "myweb"
  }
}