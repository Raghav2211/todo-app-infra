locals {
  tags = {
    Name        = var.repo_name
    account     = var.app.account
    project     = var.app.project
    environment = var.app.environment
    application = var.app.application
    team        = var.app.team
  }
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "= 1.4.0"

  repository_name = var.repo_name
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = var.keep_no_of_images
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = local.tags
}