provider "aws" {
  region = var.region
}

module "mysql" {
  source    = "../../modules/bastion"
  ssh_users = var.ssh_users
  app       = var.app
}