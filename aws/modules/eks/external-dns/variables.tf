variable "aws_region" { type = string }

variable "environment" { type = string }

variable "domain_filters" { type = list(string) }

variable "oidc_provider_arn" { type = string }

variable "tags" { type = map(string) }