terraform {
  backend "local" {
    path = "services/todo/database/terraform.tfstate"
  }
}