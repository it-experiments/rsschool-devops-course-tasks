terraform {
  backend "s3" {
    bucket = "santarossa-terraform-state-bucket"
    key    = "dev/terraform.tfstate"
    region = "eu-north-1"
    encrypt = true  
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "this" {
  bucket = "santarossa-rsschool-bucket"

  tags = {
    Name        = "Terraform rsschool Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

