module "pipeline_vpc" {
  source                         = "modules/vpc_module"
  key_name                       = "${var.key_name}"
  cidr_block                     = "${var.pipeline_cidr_block}"
  vpc_external_access_cidr_block = "${var.pipeline_external_access_cidr_block}"
  vpc_private_subnet_cidr_blocks = "${var.pipeline_private_subnet_cidr_blocks}"
  vpc_public_subnet_cidr_blocks  = "${var.pipeline_public_subnet_cidr_blocks}"
  vpc_availability_zones         = "${var.pipeline_availability_zones}"
  nat_gateway_ids                = "${module.nat.instance_ids}"
  whitelist_cidr_blocks          = "${var.pipeline_external_access_cidr_block}"
  iam_ecs                        = "${module.pipeline_ecs.iam_ecs}"
  dns_zone_name                  = "${var.dns_zone}"
  stack_details                  = "${var.stack_details}"
}

module "nat" {
  source                 = "modules/tf_aws_nat"
  name                   = "${var.stack_details["stack_name"]}"
  instance_type          = "t2.nano"
  instance_count         = "2"
  aws_key_name           = "paddle-planner-new-launch-key"
  public_subnet_ids      = "${module.pipeline_vpc.public_subnet_ids}"
  private_subnet_ids     = "${module.pipeline_vpc.private_subnet_ids}"
  vpc_security_group_ids = ["${module.pipeline_vpc.security_group_nat_id}"]
  az_list                = "[${var.pipeline_availability_zones}]"
  subnets_count          = "${length(var.pipeline_availability_zones)}"
  route_table_identifier = "private"
  ssh_bastion_user       = "ec2-user"
  ssh_bastion_host       = "${module.pipeline_vpc.bastion_private_ip}"
  aws_key_location       = "${file("/tmp/paddle-planner-new-launch-key.pem")}"
  stack_details          = "${var.stack_details}"
}

module "pipeline_ecs" {
  source             = "modules/ecs_terraform_module"
  vpc_id             = "${module.pipeline_vpc.id}"
  public_subnet_ids  = "${module.pipeline_vpc.public_subnet_ids}"
  private_subnet_ids = "${module.pipeline_vpc.private_subnet_ids}"
  efs_mount_dns      = "${module.pipeline_storage.efs_mount_dns}"
  dns_zone           = "${var.dns_zone}"
  ssh_key            = "${var.key_name}"
  stack_details      = "${var.stack_details}"
  vpc_cidr           = "${var.pipeline_cidr_block}"

  whitelist_cidr_blocks = [
    "${formatlist("%s/32", module.nat.private_ips)}",
  ]

  low_port              = 8080                                         #TODO mmmm
  high_port             = 9000
  ecs_params            = "${var.ecs_params}"
  cloudwatch_log_handle = "${module.pipeline_cloudwatch.cw_handle[0]}"
  alb_target_groups     = "${list(var.thttpd_definition)}"
}

module "pipeline_vpn" {
  source                = "modules/openvpn_terraform_module"
  vpc_id                = "${module.pipeline_vpc.id}"
  subnets               = "${module.pipeline_vpc.public_subnet_ids}"
  whitelist_cidr_blocks = "${var.pipeline_external_access_cidr_block}"
  vpn_instance_details  = "${var.vpn_instance_details}"
  dns_zone              = "${var.dns_zone}"
  stack_details         = "${var.stack_details}"
}
