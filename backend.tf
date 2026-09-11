terraform {
  backend "s3" {
    bucket = "tfstate-197166774191-us-east-1"
    key = "platform-stack/v0.1/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}
