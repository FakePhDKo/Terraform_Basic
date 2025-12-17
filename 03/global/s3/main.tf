###################################################
# 1. S3 bucket 생성
# 2. DynamoDB Table 생성
###################################################

# S3 Bucket
resource "aws_s3_bucket" "my-tfstate" {
  bucket = "kms-0818"

  tags = {
    Name        = "kms-0818"
  }
}

# Dynamo DB
resource "aws_dynamodb_table" "my_tflocks" {
  name           = "my_tflocks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "my_tflocks"
  }
}