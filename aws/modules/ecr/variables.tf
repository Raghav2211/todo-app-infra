variable "app" {
  type = object(
    {
      environment = string # dev, uat
      account     = string # lab, prd
      project     = string # todo
      application = string # edge,config etc.
      team        = string # todo
    }
  )
}

variable "repo_name" {
  type = string
}

variable "keep_no_of_images" {
  type = number
}