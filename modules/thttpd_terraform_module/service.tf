resource "aws_ecs_service" "thttpd_service" {
  name            = "${replace(lookup(var.pipeline_definition,"name"),".","-")}" #dns friendly
  cluster         = "${lookup(var.ecs_details,"cluster_id")}"
  task_definition = "${aws_ecs_task_definition.thttpd.arn}"
  desired_count   = "${lookup(var.pipeline_definition,"instance_count")}"
  iam_role        = "${lookup(var.ecs_details,"iam_role")}"

  load_balancer {
    target_group_arn = "${var.target_group_id}"
    container_name   = "${lookup(var.pipeline_definition,"name")}"
    container_port   = "${lookup(var.pipeline_definition,"container_port_to_expose")}"
  }
}
