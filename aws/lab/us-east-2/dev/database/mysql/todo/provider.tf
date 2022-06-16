terraform {

  backend "s3" {
    bucket         = "todo-state-lab"
    key            = "mysql/todo.tf"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-lock"
  }
  required_version = "= 1.2.2"
}