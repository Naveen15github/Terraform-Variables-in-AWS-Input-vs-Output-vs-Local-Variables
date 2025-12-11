# Simple S3 Bucket using all three types of variables
resource "aws_s3_bucket" "demo" {
  bucket = "naveen-tf-s3"  # Local variable (computed)

  tags = {
    Name = "MyBucket"
    Environment = "Dev"
  }
}
