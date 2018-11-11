variable "dns_zone" {}

variable "key_name" {
  #  default = "my-test-key"
}

variable "stack_details" {
  type = "map"

  default = {
    stack_id   = "PaddlePlanner-1"
    stack_name = "PaddlePlanner"
    env        = "dev"
  }
}

variable "vpn_instance_details" {
  type = "map"
}

variable "ecs_params" {
  type = "map"

  default = {
    min_instances     = 1
    max_instances     = 3
    desired_instances = 1
    ecs_name          = "PaddlePlanner"
    instance_type     = "t2.micro"
  }
}

variable "region" {
  default = "us-west-1"
}

# Pipeline CIDR Stuff
variable "pipeline_cidr_block" {
  default = "10.171.0.0/16"
}

variable "pipeline_external_access_cidr_block" {
  type = "list"
}

variable "pipeline_public_subnet_cidr_blocks" {
  type    = "list"
  default = ["10.171.77.128/25", "10.171.78.0/25"]
}

variable "pipeline_private_subnet_cidr_blocks" {
  type    = "list"
  default = ["10.171.76.0/25", "10.171.76.128/25"]
}

variable "pipeline_availability_zones" {
  type    = "list"
  default = ["us-west-1a", "us-west-1b"]
}

variable "thttpd_definition" {
  type = "map"
}
