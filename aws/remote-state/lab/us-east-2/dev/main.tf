module "tf_state" {
  source = "../../../../modules/tf-state"
  app = {
    environment = "dev"
    account     = "lab"
  }
}