resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "6.6.0"
  values = [
    templatefile("${path.module}/values.tftpl", {
      AWS_REGION     = var.aws_region
      DOMAIN_FILTERS = var.domain_filters
  })]
}