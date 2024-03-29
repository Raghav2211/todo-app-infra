variable "app" {
  type = object(
    {
      environment = string # dev, uat
      account     = string # lab, prd
      region      = string
    }
  )
}

variable "hosted_zones_name" { type = list(string) }

variable "hosted_zones_ids" { type = list(string) }
