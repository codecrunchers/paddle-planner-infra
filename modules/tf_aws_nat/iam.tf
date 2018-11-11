resource "aws_iam_instance_profile" "nat_profile" {
  name = "${var.name}-nat_ha_profile"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role" "role" {
  name               = "${var.stack_details["stack_name"]}-nat-ha-role"
  assume_role_policy = "${file("${path.module}/policies/ec2-iam-role.json")}"
}

resource "aws_iam_role_policy" "modify_routes" {
  name   = "nat_ha_modify_routes"
  role   = "${aws_iam_role.role.id}"
  policy = "${file("${path.module}/policies/ec2-iam-role-policy.json")}"
}
