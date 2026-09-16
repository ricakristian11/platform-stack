# One-line blocks may hold exactly ONE argument. Multi-line, always.

# ---- network module ----
moved {
  from = aws_vpc.main
  to = module.network.aws_vpc.main
}
moved {
  from = aws_internet_gateway.main
  to   = module.network.aws_internet_gateway.main
}
moved {
  from = aws_subnet.public
  to   = module.network.aws_subnet.public
}
moved {
  from = aws_route_table.public
  to   = module.network.aws_route_table.public
}
moved {
  from = aws_route.public_internet
  to   = module.network.aws_route.public_internet
}
moved {
  from = aws_route_table_association.public
  to   = module.network.aws_route_table_association.public
}
moved {
  from = aws_security_group.alb
  to   = module.network.aws_security_group.alb
}
moved {
  from = aws_security_group.app
  to   = module.network.aws_security_group.app
}
moved {
  from = aws_vpc_security_group_ingress_rule.alb_http
  to   = module.network.aws_vpc_security_group_ingress_rule.alb_http
}
moved {
  from = aws_vpc_security_group_egress_rule.alb_all
  to   = module.network.aws_vpc_security_group_egress_rule.alb_all
}
moved {
  from = aws_vpc_security_group_ingress_rule.app_from_alb
  to   = module.network.aws_vpc_security_group_ingress_rule.app_from_alb
}
moved {
  from = aws_vpc_security_group_egress_rule.app_all
  to   = module.network.aws_vpc_security_group_egress_rule.app_all
}

# ---- service module ----
moved {
  from = aws_ecs_cluster.main
  to   = module.service.aws_ecs_cluster.main
}
moved {
  from = aws_ecs_cluster_capacity_providers.main
  to   = module.service.aws_ecs_cluster_capacity_providers.main
}
moved {
  from = aws_cloudwatch_log_group.app
  to   = module.service.aws_cloudwatch_log_group.app
}
moved {
  from = aws_ecs_task_definition.app
  to   = module.service.aws_ecs_task_definition.app
}
moved {
  from = aws_ecs_service.app
  to   = module.service.aws_ecs_service.app
}
moved {
  from = aws_iam_role.task_execution
  to   = module.service.aws_iam_role.task_execution
}
moved {
  from = aws_iam_role.task
  to   = module.service.aws_iam_role.task
}
moved {
  from = aws_iam_role_policy_attachment.task_execution
  to   = module.service.aws_iam_role_policy_attachment.task_execution
}
moved {
  from = aws_lb.main
  to   = module.service.aws_lb.main
}
moved {
  from = aws_lb_target_group.app
  to   = module.service.aws_lb_target_group.app
}
moved {
  from = aws_lb_listener.http
  to   = module.service.aws_lb_listener.http
}
