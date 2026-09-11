resource "aws_security_group" "alb" {
  name        = "${local.name}-alb"
  description = "HTTP from the internet to the ALB"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "${local.name}-alb-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from anywhere"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  description       = "All outbound"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all protocols — from_port/to_port MUST be omitted
}

resource "aws_security_group" "app" {
  name        = "${local.name}-app"
  description = "App port from the ALB only"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "${local.name}-app-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  description                  = "App port from the ALB security group"
  referenced_security_group_id = aws_security_group.alb.id # SG-to-SG
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "app_all" {
  security_group_id = aws_security_group.app.id
  description       = "All outbound - ECR pulls and log writes"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
