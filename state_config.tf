terraform {
  backend "s3" {
    region  = "us-west-2"
    bucket  = "eks-brightloom-poc"
    key     = "terraform.tfstate"
    encrypt = "true"
  }
}

