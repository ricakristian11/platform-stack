module "network" {
  source = "./modules/network"

  project        = var.project
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  app_port       = var.app_port
}

module "service" {
  source = "./modules/service"

  project   = var.project
  region    = var.region
  app_port  = var.app_port
  image_uri = "${aws_ecr_repository.app.repository_url}:1.0"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids
  alb_sg_id  = module.network.alb_security_group_id
  app_sg_id  = module.network.app_security_group_id
}
