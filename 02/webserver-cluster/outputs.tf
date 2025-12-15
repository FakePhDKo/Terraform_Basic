output "myalb_dnsname" {
  description = "My ALB DNS name"
  value = aws_lb.myalb.dns_name
}

output "myalb_url" {
  description = "My ALB DNS url"
  value = "http://${aws_lb.myalb.dns_name}"
}
