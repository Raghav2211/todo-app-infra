terraform {
  backend "local" {
    path = "./network/terraform.tfstate"
  }
}