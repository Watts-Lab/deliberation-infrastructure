data "aws_iam_policy_document" "allow_access" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    sid = "AssetsBucketPublicAccess"
  }
}

//make new s3 bucket
resource "aws_s3_bucket" "deliberation-assets" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "public" {
  bucket = aws_s3_bucket.deliberation-assets.id
  policy = data.aws_iam_policy_document.s3_bucket.allow_access.json
}


resource "aws_s3_bucket_website_configuration" "deliberation-assets"{
  bucket = aws_s3_bucket.deliberation-assets.bucket
  index_document {
    suffix = "README.md"
  }
}

resource "aws_s3_bucket_public_access_block" "deliberation-assets-public-access-block" {
  bucket = aws_s3_bucket.deliberation-assets.id

  block_public_acls       = false //allow public access
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

//enable versioning to prevent overwriting or deletion and to archive previous versions
resource "aws_s3_bucket_versioning" "versioning-deliberation-assets" {
  bucket = aws_s3_bucket.deliberation-assets.bucket
  versioning_configuration {
    status = "Enabled"
  }
}