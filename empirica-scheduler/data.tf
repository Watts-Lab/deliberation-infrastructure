data "terraform_remote_state" "shared" {
  backend = "remote"

  config = {
    organization = var.org_name
    workspaces = {
      name=var.shared_workspace_name
    }
  }
}