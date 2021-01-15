# Provider configuration
provider "aws" {
  region = var.region
  ignore_tags {
    keys = [
      "AppId",
      "App",
      "Version",
      "Role",
      "Environment",
      "CreateAt"
    ]
  }
}