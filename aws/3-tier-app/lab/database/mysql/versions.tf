terraform {
  backend "local" {
    path = "database/terraform.tfstate"
  }
}