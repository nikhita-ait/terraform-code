terraform {
  backend "s3" {
    bucket = "pineapplebucket123"
    key    = "env/prod/terraform.tfstate"
    region = "us-east-1"
  }
}
