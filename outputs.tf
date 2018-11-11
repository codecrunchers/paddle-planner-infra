output "vpn_ip" {
  value = "${module.pipeline_vpn.vpn_ip}"
}

output "pipeline_vpc_cidr_block" {
  value = "${module.pipeline_vpc.cidr_block}"
}

output "pipeline_vpc_id" {
  value = "${module.pipeline_vpc.id}"
}

output "pipeline_private_subnet_ids" {
  value = ["${module.pipeline_vpc.private_subnet_ids}"]
}

output "pipeline_public_subnet_ids" {
  value = ["${module.pipeline_vpc.public_subnet_ids}"]
}
