resource "aws_ecr_repository" "app" {
  name = "${local.name}-hbsvc"
  image_tag_mutability = "IMMUTABLE"
  force_delete = true
  encryption_configuration { encryption_type = "AES256" }
  tags = { Name = "${local.name}-hbsvc" }
}

# keep storage bounded. Rules MUST be in ascending rulePriority order,
# or Terraform sees a phantom diff on every plan.
resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection    = { tagStatus = "any", countType = "imageCountMoreThan", countNumber = 5 }
      action       = { type = "expire" }
    }]
  })
}


