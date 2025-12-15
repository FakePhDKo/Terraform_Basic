# [입력 변수]
variable "security_group_name" {
    description = "Security Group name for my EC2"
    type = string
    default = "allow_8080"
}

variable "server_port" {
  default = 8080
  type = number
  description = "My EC2 Server Port"
}
