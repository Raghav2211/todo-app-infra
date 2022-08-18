locals {
  ingress_nginx_const = "ingress-nginx"
}

resource "helm_release" "this" {
  name             = local.ingress_nginx_const
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = local.ingress_nginx_const
  version          = "4.0.19"
  namespace        = local.ingress_nginx_const
  create_namespace = true
  values = [
    templatefile("${path.module}/../values/ingress-nginx.tftpl", {
  })]
}