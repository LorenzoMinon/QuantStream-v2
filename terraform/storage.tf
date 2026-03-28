# S3 bucket for raw data ingestion and Airflow logs
resource "aws_s3_bucket" "raw_data" {
  bucket = "${var.project_name}-raw-data-${var.aws_account_id}"

  tags = {
    Name    = "${var.project_name}-raw-data"
    Project = var.project_name
  }
}

# Block all public access — this bucket is private
resource "aws_s3_bucket_public_access_block" "raw_data" {
  bucket = aws_s3_bucket.raw_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versioning disabled — raw data gets overwritten intentionally
resource "aws_s3_bucket_versioning" "raw_data" {
  bucket = aws_s3_bucket.raw_data.id

  versioning_configuration {
    status = "Disabled"
  }
}