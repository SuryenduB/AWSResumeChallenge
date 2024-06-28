# Configure AWS provider
provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-resume-project"
    key    = "state/terraform.tfstate"
    region = "eu-central-1"
  }
}
