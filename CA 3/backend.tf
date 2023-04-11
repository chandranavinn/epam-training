terraform {
  backend "s3" {
    bucket = "terraformbucketforstate"
    key    = "remote-state-is-here/terraform.tfstate"
    region = "us-east-1"
  }
}