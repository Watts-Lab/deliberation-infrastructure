# app-specific variables
variable "region" {
  default = "us-east-1"
}
variable "environment" {
  default = "prod"
}

variable "org_name" {}

variable "app_data_path" {
  type        = string
  description = "Path to app data"
  default     = "/data"
}
variable "deliberation_empirica_tag" {
  type        = string
  description = "Docker image tag for deliberation-empirica"
}

# app environment variables
variable "QUALTRICS_DATACENTER" {}
variable "REACT_APP_TEST_CONTROLS" {
  default = "disabled"
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

variable "GITHUB_PRIVATE_DATA_OWNER" {}
variable "GITHUB_PUBLIC_DATA_OWNER" {}
variable "GITHUB_PRIVATE_DATA_REPO" {}
variable "GITHUB_PUBLIC_DATA_REPO" {}
variable "GITHUB_PRIVATE_DATA_BRANCH" {
  default = "main"
}
variable "GITHUB_PUBLIC_DATA_BRANCH" {
  default = "main"
}
variable "ETHERPAD_API_KEY" {
  sensitive = true
}
variable "ETHERPAD_BASE_URL" {}





