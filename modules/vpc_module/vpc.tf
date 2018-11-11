resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "VPC"
    stack_id    = "${var.stack_details["stack_id"]}"
    stack_name  = "${var.stack_details["stack_name"]}"
    Environment = "${var.stack_details["env"]}"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = "${aws_vpc.default.id}"
  service_name    = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = ["${aws_route_table.public.id}", "${aws_route_table.private.*.id}"]
}

data "aws_region" "current" {
  current = true
}

resource "aws_security_group" "nat" {
  name        = "nat-sg"
  description = "Controls access to the NAT AMI"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.whitelist_cidr_blocks}", "${var.cidr_block}"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags {
    Name        = "Security for NAT"
    stack_id    = "${var.stack_details["stack_id"]}"
    stack_name  = "${var.stack_details["stack_name"]}"
    Environment = "${var.stack_details["env"]}"
  }
}
