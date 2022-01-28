# frontのecr
resource "aws_ecr_repository" "front" {
  name = "front"
}

resource "aws_ecr_lifecycle_policy" "front" {
  repository = aws_ecr_repository.front.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep last 30 release tagged images",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["latest"],
          "countType": "imageCountMoreThan",
          "countNumber": 30
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
EOF
}