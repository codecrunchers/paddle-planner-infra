# Out

output "nat_id" {
  value = "${aws_security_group.nat.id}"
}

output "cidr_block" {
  value = "${aws_vpc.default.cidr_block}"
}

output "bastion_private_ip" {
  value = "${aws_instance.bastion.private_ip}"
}

output "vpc_public_subnet_cidr_blocks" {
  value = "${var.vpc_private_subnet_cidr_blocks}"
}

output "vpc_private_subnet_cidr_blocks" {
  value = "${var.vpc_private_subnet_cidr_blocks}"
}

output "id" {
  value = "${aws_vpc.default.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "security_group_nat_id" {
  value = ["${aws_security_group.nat.id}"]
}
