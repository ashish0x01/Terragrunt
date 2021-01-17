terraform {
  source = "git::git@github.com:ashish0x01/Terragrunt.git//terraform-modules/route53?ref=v0.0.1"
}
inputs = {
  domain                 = "ashishranjan.live"
  create_certificate = false
}