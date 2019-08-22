terraform {
  backend "s3" {
    region  = "us-west-2"
    bucket  = "aws-eks-brightloom-poc"
    key     = "terraform.tfstate"
    encrypt = "true"
  }
}

