resource "aws_ecr_repository" "example" {
  name = "example"
}

resource "aws_ecr_lifecycle_policy" "example" {
  repository = aws_ecr_repository.example.name

  policy = <<EOF
    {
        "rules": [
            {
                "rulePriority" : 1,
                "description" : "Keep last 30 release tagged images",
                "selection" : {
                    "tagStatus" : "tagged",
                    "tagPrefixList" : ["release"],
                    "countType" : "imageCountMoreThan",
                    "countNumber" : 30
                },
                "action" : {
                    "type" : "expire"
                }
            }
        ]
    }
    EOF
}

# aws ecr get-login-password --region ap-northeast-1 --profile terraform | docker login --username AWS --password-stdin https://924452605616.dkr.ecr.ap-northeast-1.amazonaws.com
# aws ecr create-repository --repository-name example --region ap-northeast-1 --profile terraform
# docker build -t 924452605616.dkr.ecr.ap-northeast-1.amazonaws.com/example:latest .
# docker push 924452605616.dkr.ecr.ap-northeast-1.amazonaws.com/example:latest
# aws ecr list-images --repository-name example --region ap-northeast-1 --profile terraform
