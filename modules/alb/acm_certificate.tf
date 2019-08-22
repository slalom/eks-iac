data "aws_acm_certificate" "eks_acm_certificate" {
  domain   = "*.${var.domain_name}.io"
  statuses = ["ISSUED"]
}