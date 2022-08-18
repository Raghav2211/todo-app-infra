variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
    region      = "us-east-2"
    team        = "todo"
    name        = "test"
  }
}

variable "description" {
  default = "Todo redis security group"
}