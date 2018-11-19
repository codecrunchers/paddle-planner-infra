resource "aws_ecs_task_definition" "consul_dns" {
  family                = "${format("%s_%s_family", var.stack_details["env"], lookup(var.pipeline_definition,"name"))}"
  container_definitions = "${data.template_file.container_task_definition_file.rendered}"
}

data "template_file" "container_task_definition_file" {
  template = "${file("${path.module}/templates/client-task-definition.json")}" #hcoded to client

  vars {
    image_url        = "${var.docker_image_tag}"
    container_name   = "${lookup(var.pipeline_definition, "name")}"
    log_group_name   = "${lookup(var.ecs_details, "cw_app_pipeline_log_group")}"
    log_group_region = "${var.region}"
    consul_ip        = "${var.consul_private_ip}"
    region           = "${var.region}"
    memory           = "${lookup(var.pipeline_definition, "instance_memory_allocation")}"
    ecs_cluster      = "${lookup(var.ecs_details, "ecs_cluster")}"
    aws_region       = "${data.aws_region.current.name}"
    aws_account_id   = "${lookup(var.ecs_details, "aws_account_id")}"
    vpc_dns_server   = "${cidrhost(lookup(var.ecs_details,"vpc_cidr_block"),2)}"
  }
}

data "aws_region" "current" {
  current = true
}
