variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
    region      = "us-east-2"
  }
}

variable "domain_filters" {
  default = ["todo.tmp.dev.farm"]
}