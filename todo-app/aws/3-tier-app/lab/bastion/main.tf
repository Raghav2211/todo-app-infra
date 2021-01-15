module "bastion" {
  source    = "../../modules/bastion"
  app       = var.app
  ssh_users = var.ssh_users
}