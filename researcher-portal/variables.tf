# app-specific variables

variable "subdomain" {
  default = "researcher"
}
variable "region" {
  default = "us-east-1"
}
variable "environment" {
  default = "prod"
}

variable "org_name" {
  default = "css-lab-deliberation"
}

variable "researcher_portal_tag" {
  type        = string
  description = "Docker image tag for researcher-portal"
}

variable "memory" {
  description = "Memory for the ECS service"
  default     = 256
}

variable "cpu" {
  description = "CPU for the ECS service"
  default     = 128
}



