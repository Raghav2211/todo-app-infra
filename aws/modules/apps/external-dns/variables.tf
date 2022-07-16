variable "app" {
  type = object(
    {
      environment = string # dev, uat
      account     = string # lab, prd
    }
  )
}
variable "domain_filters" { type = list(string) }
variable "oidc_provider_arn" { type = string }
