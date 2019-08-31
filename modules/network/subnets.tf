data "aws_availability_zones" "available" {}

resource "aws_subnet" "gateway" {
  count = "${length(var.gateway_subnets)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${element(var.gateway_subnets, count.index)}"
  vpc_id            = "${aws_vpc.main_vpc.id}"
  tags = "${
    map(
     "Name", "${var.cluster_name}_gateway"
    )
  }"
}


# kubernetes will run on the application subnet
resource "aws_subnet" "application" {
  count = "${length(var.application_subnets)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${element(var.application_subnets, count.index)}"
  vpc_id            = "${aws_vpc.main_vpc.id}"
  tags = "${
    map(
     "Name", "${var.cluster_name}_application",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}

# RDS / data will run in database.
resource "aws_subnet" "database" {
  count = "${length(var.database_subnets)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${element(var.database_subnets, count.index)}"
  vpc_id            = "${aws_vpc.main_vpc.id}"
  
  tags = "${
    map(
     "Name", "${var.cluster_name}_database"
    )
  }"
}