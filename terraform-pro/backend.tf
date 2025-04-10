terraform {
  backend "s3" {
    bucket         = "elham-tf-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "elham-tf-lock-table"
  }
}


