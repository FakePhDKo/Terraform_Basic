# output "my_bucket_arn" {
#   description = "my bucket arn"
#   value = aws_s3_bucket.my-tfstate.arn
# }

output "dynamodb_table_name" {
  description = "dynamode table name"
  value = aws_dynamodb_table.my_tflocks.name
}