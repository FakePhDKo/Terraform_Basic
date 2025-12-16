output "myEC2IP" {
  description = "my EC2 IP"
  value = aws_instance.myEC2.public_ip
}

output "myEC2DNS" {
  description = "my EC2 DNS"
  value = "ssh -i ~/.ssh/id_rsa.pub ubuntu@${aws_instance.myEC2.public_dns}"
}