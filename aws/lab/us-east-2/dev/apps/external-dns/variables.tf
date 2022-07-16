variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
  }
}

variable "domain_filters" {
  default = ["todo.tmp.dev.farm"]
}