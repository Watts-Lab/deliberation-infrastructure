variable "region" {}
variable "app_name" {}
variable "subnet_cidr" {}
variable "public_subnet1" {}
variable "public_subnet2" {}
variable "acm_certificate_arn" {}
variable "project_name" {}

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