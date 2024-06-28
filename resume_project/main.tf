# Configure AWS provider
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-resume-project"
    key    = "state/terraform.tfstate"
    region = var.region
  }
}
