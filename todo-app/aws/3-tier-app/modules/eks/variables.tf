variable "app" {
  type = object(
    {
      id      = string
      version = string
      env     = string
    }
  )
}