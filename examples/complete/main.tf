module "example" {
  source = "../.."

  parameter_store_token_path       = var.parameter_store_token_path
  parameter_store_private_key_path = var.parameter_store_private_key_path
  github_app_id                    = var.github_app_id
  github_app_installation_id       = var.github_app_installation_id
  github_org                       = var.github_org

  context = module.this.context
}
