variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
  }
}

variable "node_group_config" {
  default = {
    todocom = {
      instance_type = "m5.large"
      asg = {
        min_size     = 1
        max_size     = 3
        desired_size = 2
      }
    }
  }
}
