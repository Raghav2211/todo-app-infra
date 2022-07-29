variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
    team        = "todo"
    name        = "test"
  }
}

variable "description" {
  default = "Todo redis security group"
}