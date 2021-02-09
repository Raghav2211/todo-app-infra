module "complete_cluster" {
  source = "../../"
  app = {
    id      = "psi"
    version = "1.0.0"
    env     = "lab"
  }
  region          = "us-west-2"
  cidr            = "172.31.0.0/24"
  azs             = ["us-west-2a", "us-west-2b"]
  public_subnets  = ["172.31.0.128/26", "172.31.0.192/26"]
  private_subnets = ["172.31.0.0/27", "172.31.0.32/27"]
  worker_conf = [{
    name                 = "worker-group-1"
    instance_type        = "t2.small"
    asg_desired_capacity = 2
    asg_min_size         = 2
    asg_max_size         = 4
  }]
} 