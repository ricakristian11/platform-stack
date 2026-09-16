resource "aws_ecs_service" "app" {
  name            = "${var.project}-svc"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.app_sg_id]
    assign_public_ip = true # the $3.65-vs-$33 decision, as a boolean
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "hbsvc" # must match container_definitions
    container_port   = var.app_port
  }

  health_check_grace_period_seconds = 30

  deployment_circuit_breaker {
    enable   = true
    rollback = true # a deploy that never goes healthy rolls back
  }

  depends_on = [aws_lb_listener.http] # rare legitimate depends_on
}
