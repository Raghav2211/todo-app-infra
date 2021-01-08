terraform {
  backend "local" {
    path = "bastion/terraform.tfstate"
  }
}