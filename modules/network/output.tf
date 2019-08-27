output "vpc_id" {
  value = "${aws_vpc.main_vpc.id}"
}

output "app_subnet_ids" {
  value = "${aws_subnet.application.*.id}"
}

output "gateway_subnet_ids" {
  value = "${aws_subnet.gateway.*.id}"
}

output "database_subnet_ids" {
  value = "${aws_subnet.database.*.id}"
}

output "app_cidr_block" {
  value = "${aws_subnet.application.*.cidr_block}"
}