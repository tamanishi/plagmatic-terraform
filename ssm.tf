# aws ssm put-parameter --region ap-northeast-1 --name 'plain_name' --value 'plain_value' --type String --profile terraform
# aws ssm get-parameter --region ap-northeast-1 --output text  --name 'plain_name' --query Parameter.Value --profile terraform

resource "aws_ssm_parameter" "db_username" {
  name        = "/db/username"
  value       = "root"
  type        = "String"
  description = "データベースのユーザー名"
}

# aws ssm put-parameter --region ap-northeast-1 --name '/db/password' --type SecureString --value 'ModifiedStrongPassword!' --overwrite --profile terraform

resource "aws_ssm_parameter" "db_password" {
  name        = "/db/password"
  value       = "uninitialized"
  type        = "SecureString"
  description = "データベースのパスワード"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "github_token" {
  name        = "/cicd/github_token"
  value       = "uninitialized"
  type        = "SecureString"
  description = "ci/cdのためのtoken"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_document" "session_manager_run_shell" {
  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  content = <<EOF
  {
    "schemaVersion": "1.0",
    "description": "Document to hold regional settins for Session Manager",
    "sessionType": "Standard_Stream",
    "inputs":{
      "s3BucketName": "${aws_s3_bucket.operation.id}",
      "cloudWatchLogGroupName": "${aws_cloudwatch_log_group.operation.name}"
    }
  }
EOF
}

# brew install --cask session-manager-plugin
