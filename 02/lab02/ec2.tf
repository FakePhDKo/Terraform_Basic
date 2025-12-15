########################
# 1. Provider
# 2. ec2
# - SG
# - EC2(keypair)
########################


########################
# Provider 설정
########################
provider "aws" {
    region = "us-east-2"
    profile = "myAWS"
}

data "aws_vpc" "default" {
  default = true
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
  name        = "allow_tls"
  description = "Allow TLS inbound SSH traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "mysg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Key Pair
resource "aws_key_pair" "mykeypair" {
  key_name = "mykeypair"
  public_key = file("~/.ssh/id_rsa.pub")
}


# EC2 생성
# Resource: aws_instance
# * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
data "aws_ami" "amazon2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.9.*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] 
}

resource "aws_instance" "myInstance" {
  ami           = data.aws_ami.amazon2023.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]

  key_name = "mykeypair"

  tags = {
    Name = "myInstance"
  }
}

output "ami_id" {
  description = "ami_id"
  value = aws_instance.myInstance.ami
}

output "myInstanceIP" {
  description = "my Instance Public IP"
  value = aws_instance.myInstance.public_ip
}

output "connectSSH" {
  description = "connect URL"
  value = "ssh -i ~/.ssh/mykeypair ec2-user@${aws_instance.myInstance.public_ip}"
}