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

module "pp_webapp" {
  source        = "modules/paddleplanner_terraform_module"
  stack_details = "${var.stack_details}"

  pipeline_definition = "${var.pp_webapp_definition}"
  docker_image_tag    = "${var.pp_webapp_definition["docker_image_tag"]}"

  ecs_details = {
    cluster_id                = "${module.pipeline_ecs.cluster_id}"                                        #TODO: Refactor these maps, messy
    iam_role                  = "${module.pipeline_ecs.iam_role}"
    cw_app_pipeline_log_group = "${var.stack_details["stack_name"]}/${var.stack_details["env"]}/pp_webapp"
  }

  target_group_id = "${module.pipeline_ecs.target_group_id[0]}" #thttpd (index into list)
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
  }

  target_group_id = "${module.pipeline_ecs.target_group_id[0]}" #thttpd (index into list)
}

#Old Format Module

#module "registrator" {
#  source                 = "modules/registrator_terraform_module"
#  environment            = "${var.environment}"
#  name                   = "${var.name}"
#  docker_image_tag       = "${var.registrator_definition["docker_image_tag"]}"
#  registrator_definition = "${var.registrator_definition}"
# consul_private_ip      = "${module.pipeline_vpc.consul_private_ip}"

#  ecs_details = {
#    desired_count             = 0
#    cluster_id                = "${module.pipeline_ecs.cluster_id}"
#    iam_role                  = "${module.pipeline_ecs.iam_role}"
#    cw_app_pipeline_log_group = "${var.name}/${var.environment}/registrator"
#  }

# region          = "${var.region}"
# target_group_id = ""
#}

module "consul" {
  source              = "modules/consul_terraform_module"
  stack_details       = "${var.stack_details}"
  pipeline_definition = "${var.consul_definition}"
  docker_image_tag    = "${var.consul_definition["docker_image_tag"]}"
  consul_private_ip   = "${module.pipeline_vpc.consul_private_ip}"
  efs_mount_dns       = "${module.pipeline_storage.efs_mount_dns}"

  ecs_details = {
    cluster_id                = "${module.pipeline_ecs.cluster_id}"                                     #TODO: Refactor these maps, messy
    iam_role                  = "${module.pipeline_ecs.iam_role}"
    cw_app_pipeline_log_group = "${var.stack_details["stack_name"]}/${var.stack_details["env"]}/consul"
    vpc_cidr_block            = "${module.pipeline_vpc.cidr_block}"
    ecs_cluster               = "${module.pipeline_ecs.cluster_name}"
    aws_account_id            = "${data.aws_caller_identity.current.account_id}"
  }
}

module "pipeline_ecr" {
  source        = "modules/ecr_terraform_module"
  registries    = ["pipeline.thttpd", "pp.webapp", "pp.mongo", "pp.consul"]
  stack_details = "${var.stack_details}"
}
