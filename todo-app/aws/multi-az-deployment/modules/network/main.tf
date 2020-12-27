module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name = "${var.name}-${var.env}"

  cidr = var.cidr

  #private_subnets = "${var.private_subnets}"
  #public_subnets = "${var.public_subnets}"
  vpc_tags = {
    App         = var.name
    Environment = var.env
  }

}

