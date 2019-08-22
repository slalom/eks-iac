provider "aws" {
  region     = "${var.aws_region}"
  version    = "~> 2.24.0"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

# Not required: currently used in conjuction with using
# icanhazip.com to determine local workstation external IP
# to open EC2 Security Group access to the Kubernetes cluster.
# See workstation-external-ip.tf for additional information.
provider "http" {
  version = "~> 1.1"
}

provider "external" {
  version = "~> 1.2"
}

