terraform {
  source = "git::git@github.com:ashish0x01/Terragrunt.git//terraform-modules/vpc?ref=v0.0.1"
}
inputs = {
  name                 = "terragrunt-dev-vpc"
  enable_dns_support   = true
  enable_dns_hostnames = true
  vpc_cidr             = "10.100.0.0/16"
  public_subnets_cidr  = "10.100.10.0/24,10.100.20.0/24"
  private_subnets_cidr = "10.100.30.0/24,10.100.40.0/24"
  azs                  = "us-east-2a,us-east-2b"
}