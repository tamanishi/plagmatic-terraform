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
