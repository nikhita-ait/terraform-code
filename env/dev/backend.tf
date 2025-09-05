terraform {
  backend "s3" {
    bucket = "pineapplebucket1234"
    key    = "env/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
