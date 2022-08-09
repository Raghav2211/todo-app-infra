variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
    id          = "{ACCOUNT_ID}FIXME"
  }
}

variable "default_tags" {
  type = map(string)
  default = {
    account     = "lab"
    project     = "kms"
    environment = "dev"
    team        = "sre"
  }
}

