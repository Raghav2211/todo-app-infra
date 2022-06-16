terraform {

  backend "s3" {
    bucket         = "tf-state-lab-dev"
    key            = "app/todo.tf"
    region         = "us-east-2"
    dynamodb_table = "tf-state-lab-dev"
  }
  required_version = "= 1.2.2"
}