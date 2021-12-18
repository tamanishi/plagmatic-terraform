resource "aws_s3_bucket" "private" {
  bucket = "private-tamanishi-plagmatic-terraform"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-tamanishi-plagmatic-terraform"

  lifecycle_rule {
    enabled = true

    expiration {
      days = 180
    }
  }
}
