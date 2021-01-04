terraform {
  backend "local" {
    path = "./vpc/terraform.tfstate"
  }
}