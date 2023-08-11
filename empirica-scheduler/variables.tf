# app-specific variables
variable "org_name" {} 
variable "shared_workspace_name" {}
variable "region" {}

# app environment variables

variable "DELIBERATION_MACHINE_USER_TOKEN" {
  sensitive = true
}
