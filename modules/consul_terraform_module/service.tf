resource "aws_ecs_service" "consul_ecs_service" {
  name            = "${replace(lookup(var.pipeline_definition,"name"),".","-")}" #dns friendly
  cluster         = "${lookup(var.ecs_details,"cluster_id")}"
  task_definition = "${aws_ecs_task_definition.consul_dns.arn}"
  desired_count   = "${lookup(var.pipeline_definition,"instance_count")}"
}
