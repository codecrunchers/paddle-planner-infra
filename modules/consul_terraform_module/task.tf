resource "aws_ecs_task_definition" "consul" {
  family                = "${format("%s_%s_family", var.stack_details["env"],lookup(var.pipeline_definition,"name"))}"
  container_definitions = "${data.template_file.container_task_definition_file.rendered}"
}

data "template_file" "container_task_definition_file" {
  template = "${file("${path.module}/templates/client-task-definition.json")}"

  vars {
    image_url        = "${var.docker_image_tag}"
    container_name   = "${lookup(var.pipeline_definition, "name")}"
    log_group_name   = "${lookup(var.ecs_details, "cw_app_pipeline_log_group")}"
    log_group_region = "${var.region}"
    container_port   = "${lookup(var.pipeline_definition, "container_port_to_expose")}"
    host_port        = "${lookup(var.pipeline_definition, "host_port_to_expose")}"
    memory           = "${lookup(var.pipeline_definition, "instance_memory_allocation")}"
    consul_ip        = "${var.consul_private_ip}"
    region           = "${var.region}"
  }
}
