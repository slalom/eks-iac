resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags = {
    Name = "internet_gateway"
  }
}


resource "aws_eip" "the_eip" {
  count = "${var.subnet_count}"
  vpc      = true
}

resource "aws_nat_gateway" "the_nat_gateway" {
  count = "${var.subnet_count}"
  allocation_id = "${aws_eip.the_eip.*.id[count.index]}"
  subnet_id = "${aws_subnet.gateway.*.id[count.index]}"
  tags = {
    Name = "nat_gateway"
  }
  depends_on = ["aws_internet_gateway.internet_gateway"]
}