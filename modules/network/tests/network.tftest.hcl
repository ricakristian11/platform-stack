mock_provider "aws" {
  # the module indexes AZ names[0] and names[1]; give the mock real ones
  mock_data "aws_availability_zones" {
    defaults = {
      names = ["us-east-1a", "us-east-1b"]
    }
  }
}

variables {
  project        = "test"
  vpc_cidr       = "10.0.0.0/16"
  public_subnets = { a = "10.0.1.0/24", b = "10.0.2.0/24" }
  app_port       = 8080
}

run "creates_two_public_subnets" {
  command = plan

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "expected exactly two public subnets"
  }

  assert {
    condition     = aws_subnet.public["a"].availability_zone == "us-east-1a"
    error_message = "subnet a should land in us-east-1a"
  }
}

run "app_sg_references_alb_sg" {
  command = plan

  assert {
    condition     = aws_vpc_security_group_ingress_rule.app_from_alb.from_port == var.app_port
    error_message = "app ingress must match app_port"
  }
}

run "rejects_bad_cidr" {
  command = plan

  variables {
    vpc_cidr = "not-a-cidr"
  }

  expect_failures = [var.vpc_cidr]
}
