variable "app" {
  default = {
    account = "lab"
    region  = "us-east-2"
  }
}

variable "cluster_iam_role_name" {
  default = "lab-eks-cluster-role"
}

variable "cluster_role_policies" {
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
}

variable "node_group_iam_role_name" {
  default = "lab-eks-node-group-role"
}

variable "node_group_role_policies" {
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}