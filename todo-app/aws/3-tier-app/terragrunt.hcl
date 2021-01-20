# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  app = {
    id      = "psi"
    version = "1.0.0"
    env     = "${local.environment_vars.locals.env}"
  }
   region = "${local.environment_vars.locals.region}"
 
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
{ app = "${local.app}" },
{cidr             = "172.31.0.0/24"},
{azs              = ["us-west-2a", "us-west-2b"]},
{public_subnets   = ["172.31.0.128/26", "172.31.0.192/26"]},
{private_subnets  = ["172.31.0.0/27", "172.31.0.32/27"]},
{database_subnets = ["172.31.0.64/27", "172.31.0.96/27"]},
{create_database_subnet_group = true}

)