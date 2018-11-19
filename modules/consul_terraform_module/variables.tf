variable "stack_details" {
  type = "map"
}

variable "pipeline_definition" {
  type = "map"
}

variable "ecs_details" {
  type = "map"
}

variable "docker_image_tag" {}

variable "consul_private_ip" {}

variable "region" {
  default = "us-west-1"
}

variable "efs_mount_dns" {}
