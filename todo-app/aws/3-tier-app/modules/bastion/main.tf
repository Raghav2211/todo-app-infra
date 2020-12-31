data "aws_region" "current" {}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "terraform_remote_state" "vpc" {
  backend = "local"
}

module "sg_ssh" {
  source                 = "terraform-aws-modules/security-group/aws//modules/ssh"
  version                = "3.17.0"
  name                   = "sg-${data.aws_region.current.name}-${substr(var.app.env,0,1)}-${var.app.id}${var.app.name}${var.app.suffix != "" ? "-${var.app.suffix}" : ""}"  
  vpc_id                 = data.terraform_remote_state.vpc.outputs.vpc_id
  description            = var.description
  ingress_cidr_blocks    = concat(var.ingress_cidr, ["${chomp(data.http.myip.body)}/32"])
  use_name_prefix        = false
  auto_ingress_with_self = []

  tags = {
    AppId       = var.app.id
    App         = var.app.name
    Version     = var.app.version
    Role        = "infra"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}