output "naveen-tf-s3" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.demo.bucket
}

output "naveen-tf-s3-output1" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.demo.arn
}

output "environment" {
  description = "Environment from input variable"
  value       = var.environment
}

output "naveen-tf-s3-output2" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.demo.bucket
}