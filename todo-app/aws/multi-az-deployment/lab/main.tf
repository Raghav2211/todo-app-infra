provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../modules/network"

  name = var.name

  env = "lab"

  cidr = var.cidr

  #  public_subnets = "${var.public_subnets}"
}

