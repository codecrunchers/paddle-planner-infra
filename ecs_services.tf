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
    {
      name              = "pp_webapp"
      retention_in_days = 14
    },
    {
      name              = "mongo"
      retention_in_days = 14
    },
    {
      name              = "consul"
      retention_in_days = 14
    },
    {
      name              = "registrator"
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

module "pp_webapp" {
  source        = "modules/paddleplanner_terraform_module"
  stack_details = "${var.stack_details}"

  pipeline_definition = "${var.pp_webapp_definition}"
  docker_image_tag    = "${var.pp_webapp_definition["docker_image_tag"]}"

  ecs_details = {
    cluster_id                = "${module.pipeline_ecs.cluster_id}"                                        #TODO: Refactor these maps, messy
    iam_role                  = "${module.pipeline_ecs.iam_role}"
    cw_app_pipeline_log_group = "${var.stack_details["stack_name"]}/${var.stack_details["env"]}/pp_webapp"
    consul_private_ip         = "${module.pipeline_vpc.consul_private_ip}"
  }

  target_group_id = "${module.pipeline_ecs.target_group_id[0]}" #(index into a list)
}

module "mongo" {
  source        = "modules/mongo_terraform_module"
  stack_details = "${var.stack_details}"

  pipeline_definition = "${var.mongo_definition}"
  docker_image_tag    = "${var.mongo_definition["docker_image_tag"]}"

  ecs_details = {
    cluster_id                = "${module.pipeline_ecs.cluster_id}"                                    #TODO: Refactor these maps, messy
    iam_role                  = "${module.pipeline_ecs.iam_role}"
    cw_app_pipeline_log_group = "${var.stack_details["stack_name"]}/${var.stack_details["env"]}/mongo"
    consul_private_ip         = "${module.pipeline_vpc.consul_private_ip}"
  }
}

module "pipeline_ecr" {
  source        = "modules/ecr_terraform_module"
  registries    = ["paddle-planner-thttpd", "paddle-planner-webapp", "paddle-planner-mongo", "paddle-planner-consul"]
  stack_details = "${var.stack_details}"
}
