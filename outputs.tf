output "alb_url" {
  value = module.service.alb_url
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "log_group_name" {
  value = module.service.log_group_name
}
