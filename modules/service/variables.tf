variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "app_port" {
  type = number
}

variable "image_uri" {
  type        = string
  description = "Full ECR image URI with tag"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "alb_sg_id" {
  type = string
}

variable "app_sg_id" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "cpu" {
  type    = number
  default = 256
  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.cpu)
    error_message = "cpu must be a valid Fargate value."
  }
}

variable "memory" {
  type    = number
  default = 512
}
