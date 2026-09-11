variable "project" {
  type        = string
  description = "Naming prefix"
  default     = "platform-stack"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0)) # can() turns an error into false
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}

variable "public_subnets" {
  type        = map(string)
  description = "subnet key => CIDR"
  default     = { a = "10.0.1.0/24", b = "10.0.2.0/24" }
}

variable "app_port" {
  type        = number
  description = "Container listen port"
  default     = 8080
}
