# app-specific variables
variable "region" {
  default = "us-east-1"
}
variable "environment" {
  default = "prod"
}

variable "org_name" {}


variable "deliberation_etherpad_tag" {
  type        = string
  description = "Docker image tag for deliberation-etherpad"
}

variable "admin_pw" {
  type        = string
  description = "etherpad admin interface password"
}




