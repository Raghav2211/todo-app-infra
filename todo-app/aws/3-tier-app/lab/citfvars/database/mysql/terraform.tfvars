region = "us-west-2"

app = {
  id      = "psi"
  version = "1.0.0"
  env     = "lab"
}

instance_type   = "db.t2.micro"
master_user     = "testtodo"
master_password = "password"
multi_az        = false