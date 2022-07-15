variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
  }
}

variable "external_dns" {
  default = {
    create         = true
    domain_filters = ["todo.tmp.dev.farm"]
  }
}