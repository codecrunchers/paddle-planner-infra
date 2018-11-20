data "aws_route53_zone" "main" {
  name = "${var.dns_zone}"

  #  vpc_id = "${aws_vpc.default.id}"
}
