//make new s3 bucket
resource "aws_s3_bucket" "deliberation-assets-bucket"{
  bucket = var.bucket_name

  tags = {
    deployBy = "terraform"
    app = "deliberation-assets"
  }
}

//enable versioning to prevent overwriting or deletion and to archive previous versions
resource "aws_s3_bucket_versioning" "versioning-deliberation-assets" {
  bucket = aws_s3_bucket.deliberation-assets-bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}