region = "us-west-2"

app = {
  id      = "psi"
  name    = "todo"
  version = "1.0.0"
  env     = "lab"
}

image_id      = "ami-*****************"
instance_type = "t2.micro"

app_env_vars = {
  MYSQL_HOST     = "rds-us-west-2-l-psi-mysql.************.us-west-2.rds.amazonaws.com"
  MYSQL_DB_NAME  = "psi"
  MYSQL_USER     = "testtodo"
  MYSQL_PASSWORD = "password"
}
