output "consul_private_ip" {
  value = "${aws_instance.consulinstance.private_ip}"
}

output "consul_public_ip" {
  value = "${aws_instance.consulinstance.public_ip}"
}

variable "whitelist_cidr_blocks" {
  type = "list"
}

variable "nat_gateway_ids" {
  type = "list"
}

variable "stack_details" {
  type = "map"
}

variable "iam_ecs" {}

variable "dns_zone_name" {
  type = "string"
}

variable "key_name" {}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "vpc_external_access_cidr_block" {
  default = "0.0.0.0/0"
}

variable "vpc_public_subnet_cidr_blocks" {
  type    = "list"
  default = ["10.0.0.0/24", "10.0.2.0/24"]
}

variable "vpc_private_subnet_cidr_blocks" {
  type    = "list"
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "vpc_availability_zones" {
  type = "list"
}

variable "ecs_amis" {
  type = "map"

  default = {
    us-west-1 = "ami-04c22ba97a0c063c4"
    us-west-2 = "ami-09568291a9d6c804c"
  }
}
