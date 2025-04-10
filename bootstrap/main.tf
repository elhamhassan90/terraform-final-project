provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Create S3 bucket for remote state
resource "aws_s3_bucket" "tf_state" {
  bucket = "elham-tf-state-bucket"

  tags = {
    Name = "Terraform State Bucket"
  }
}

# Enable server-side encryption (separate resource as recommended)
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable versioning on the S3 bucket (separate resource)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "tf_lock" {
  name         = "elham-tf-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform Lock Table"
  }
}

