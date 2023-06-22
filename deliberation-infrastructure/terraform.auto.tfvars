# project-specific variables
project_name        = "deliberation"
subnet_cidr         = "10.0.0.0/24"
public_subnet1      = "10.0.10.0/24"
public_subnet2      = "10.0.20.0/24"
acm_certificate_arn = "arn:aws:acm:us-east-1:941654414269:certificate/e0e19345-4917-4e54-a87a-01ee32812046"

# app-specific variables
app_name             = "delib-empirica"
app_data_path        = "/data"

# app environment variables
QUALTRICS_DATACENTER    = "iad1"
GITHUB_DATA_REPO        = "Watts-Lab/deliberation-data-private"
GITHUB_BRANCH           = "main"
REACT_APP_TEST_CONTROLS = "disabled"

