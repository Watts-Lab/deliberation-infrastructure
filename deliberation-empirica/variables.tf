# app-specific variables
variable "app_name" {}
variable "org_name" {} 
variable "shared_workspace_name" {}
variable "region" {}

variable "container_image_name"{
  default = "ghcr.io/watts-lab/deliberation-empirica:latest"
}
# app environment variables
variable "QUALTRICS_DATACENTER" {}
variable "GITHUB_DATA_REPO" {}
variable "GITHUB_BRANCH" {}
variable "REACT_APP_TEST_CONTROLS" {}
variable "app_data_path" {
  type        = string
  description = "Path to app data"
  default     = "/data"
}

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



