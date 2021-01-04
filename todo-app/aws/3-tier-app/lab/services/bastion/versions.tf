terraform {
  backend "local" {
    path = "services/bastion/terraform.tfstate"
  }
}