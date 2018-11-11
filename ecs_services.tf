module "pipeline_cloudwatch" {
  source        = "modules/cloudwatch_terraform_module"
  stack_details = "${var.stack_details}"

  groups = [
    {
      name              = "ecs-pipeline-container"
      retention_in_days = 14
    },
    {
      name              = "thttpd"
      retention_in_days = 14
    },
  ]
}

module "pipeline_storage" {
  source             = "modules/filesystem_terraform_module"
  stack_details      = "${var.stack_details}"
  private_subnet_ids = "${module.pipeline_vpc.private_subnet_ids}"
  vpc_id             = "${module.pipeline_vpc.id}"
}

module "thttpd" {
  source        = "modules/thttpd_terraform_module"
  stack_details = "${var.stack_details}"

  pipeline_definition = "${var.thttpd_definition}"
  docker_image_tag    = "${var.thttpd_definition["docker_image_tag"]}"

  ecs_details = {
    cluster_id                = "${module.pipeline_ecs.cluster_id}"                                     #TODO: Refactor these maps, messy
    iam_role                  = "${module.pipeline_ecs.iam_role}"
    cw_app_pipeline_log_group = "${var.stack_details["stack_name"]}/${var.stack_details["env"]}/thttpd"
  }

  target_group_id = "${module.pipeline_ecs.target_group_id[0]}" #thttpd (index into list)
}

module "pipeline_ecr" {
  source        = "modules/ecr_terraform_module"
  registries    = ["pipeline.thttpd"]
  stack_details = "${var.stack_details}"
}
