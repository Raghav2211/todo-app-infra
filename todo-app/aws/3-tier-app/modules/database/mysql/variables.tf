variable "app" {
  type = object(
    {
      id      = string
      name    = string
      version = string
      env     = string
    }
  )
}

variable "vpc_id" {
  type        = string
  description = "ID of vpc where security group will create "
}

variable "description" {
  type        = string
  description = "Secuity group description"
  default     = "Mysql security group"
}

variable "app_sg_ids" {
  type = list(string)
}

# rds(mysql) varaibles
variable "instance_type" {
  type    = string
  default = "db.t2.micro"
}

variable "storage_size_in_gib" {
  type    = number
  default = 5
}

variable "database_name" {
  type    = string
  default = ""
}

variable "master_user" {
  type = string
  #sensitive = true
}

variable "master_password" {
  type = string
  #sensitive = true
}
variable "port" {
  type    = string
  default = "3306"
}