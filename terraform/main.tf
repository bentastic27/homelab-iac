terraform {
  backend "s3" {
    bucket = "lab.beansnet.net-tf-remote-state"
    key    = "homelab-infra"
    region = "us-east-2"
  }
}
