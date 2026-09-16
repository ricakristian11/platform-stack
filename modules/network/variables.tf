variable "project" {
  type        = string
  description = "Naming prefix"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}

variable "public_subnets" {
  type        = map(string)
  description = "subnet key => CIDR"
}

variable "app_port" {
  type        = number
  description = "Port the application listens on"
}
