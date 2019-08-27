resource "aws_vpc" "main_vpc" {
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = "${
    map(
     "Name", "terraform-eks",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}