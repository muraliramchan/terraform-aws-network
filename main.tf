resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "${terraform.workspace}"
  }
}

module "public_subnet" {
  source = "github.com/adrianmkng/terraform-aws-subnet"
  region = "${var.region}"
  vpc_id = "${aws_vpc.main.id}"
  subnet_cidr = "${cidrsubnet(var.vpc_cidr, 1, 0)}"
  azs = "${var.azs}"
  name = "${terraform.workspace}_public"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${terraform.workspace}"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(var.azs)}"

  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${element(module.public_subnet.subnet_ids, count.index)}"
}
