resource "aws_s3_bucket" "private" {
  bucket = "private-tamanishi-pragmatic-terraform"
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
  bucket = "alb-log-tamanishi-pragmatic-terraform"

  lifecycle_rule {
    enabled = true

    expiration {
      days = 180
    }
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type = "AWS"
      # fixed value for ap-northeast-1
      # see https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/classic/enable-access-logs.html
      identifiers = ["582318560864"]
    }
  }
}

# destroy時にs3の内容を自動で削除する
# https://qiita.com/ChaseSan/items/11fe05926c700220d3cc
resource "null_resource" "delete_alb_log_content" {
  triggers = {
    bucket = aws_s3_bucket.alb_log.bucket
  }

  depends_on = [
    aws_s3_bucket.alb_log
  ]

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://${self.triggers.bucket} --recursive --profile terraform"
  }
}

resource "aws_s3_bucket" "artifact" {
  bucket = "artifact-tamanishi-pragmatic-terraform"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

resource "null_resource" "delete_artifact_content" {
  triggers = {
    bucket = aws_s3_bucket.artifact.bucket
  }

  depends_on = [
    aws_s3_bucket.artifact
  ]

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://${self.triggers.bucket} --recursive --profile terraform"
  }
}

resource "aws_s3_bucket" "operation" {
  bucket = "operation-tamanishi-pragmatic-terraform"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

resource "null_resource" "delete_operation_content" {
  triggers = {
    bucket = aws_s3_bucket.operation.bucket
  }

  depends_on = [
    aws_s3_bucket.operation
  ]

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://${self.triggers.bucket} --recursive --profile terraform"
  }
}

resource "aws_s3_bucket" "cloudwatch_logs" {
  bucket = "cloudwatch-logs-tamanishi-pragmatic-terraform"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

resource "null_resource" "delete_cloudwatch_logs_content" {
  triggers = {
    bucket = aws_s3_bucket.cloudwatch_logs.bucket
  }

  depends_on = [
    aws_s3_bucket.cloudwatch_logs
  ]

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://${self.triggers.bucket} --recursive --profile terraform"
  }
}
