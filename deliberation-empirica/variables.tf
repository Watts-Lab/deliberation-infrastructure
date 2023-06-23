# app-specific variables
variable "app_name" {}
variable "org_name" {} 
variable "shared_workspace_name" {}

# app environment variables

# taken from TF_VAR_* environment variables or set on TF cloud
variable "DAILY_APIKEY" {
  sensitive = true
}
variable "QUALTRICS_API_TOKEN" {
  sensitive = true
}
variable "DELIBERATION_MACHINE_USER_TOKEN" {
  sensitive = true
}
variable "EMPIRICA_ADMIN_PW" {
  sensitive = true
}

