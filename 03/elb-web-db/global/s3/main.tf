##########################################
# 1. provider
# 2. S3 mybucket 생성
# 3. DynamoDB Table 생성
##########################################

##########################################
# 1. provider
##########################################
provider "aws" {
  region = "us-east-2"
}


##########################################
# 2. S3 mybucket 생성
##########################################
resource "aws_s3_bucket" "mytfstate" {
  bucket = "mykms-777"

  tags = {
    Name = "mytfstate"
  }
}


##########################################
# 3. DynamoDB Table 생성
##########################################
# * S3 bucket ARN -> output
# * DynamoDB table name -> output
resource "aws_dynamodb_table" "mylock" {
  name           = "mylock"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "mylock"
  }
}