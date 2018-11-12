dns_zone = "paddle-planner.com"

region = "us-west-1"

pipeline_external_access_cidr_block = ["86.45.247.140/32"] //Home,GitHUB*2

#TODO: Dup
#Key Name is Pattern _BUCKET_ID - see go.sh

key_name = "paddle-planner-new-launch-key"

#Key Name is Pattern _BUCKET_ID - see go.sh
vpn_instance_details = {
  ami      = "ami-0f64ffcaec0c6d2f2"
  size     = "t2.nano"
  key_name = "paddle-planner-new-launch-key"
}

thttpd_definition = {
  docker_image_tag           = "gists/lighttpd"
  name                       = "thttpd"
  context                    = ""
  host_port_to_expose        = "8080"
  container_port_to_expose   = "80"
  instance_memory_allocation = "512"
  instance_count             = "1"
}

pp_webapp_definition = {
  docker_image_tag           = "507358225127.dkr.ecr.us-west-1.amazonaws.com/dev.pp.webapp:latest"
  name                       = "webapp"
  context                    = "pp_webapp"
  host_port_to_expose        = "8082"
  container_port_to_expose   = "4040"
  instance_memory_allocation = "512"
  instance_count             = "1"
}

mongo_definition = {
  docker_image_tag           = "507358225127.dkr.ecr.us-west-1.amazonaws.com/dev.pp.mongo:latest"
  name                       = "mongo"
  context                    = "mongo"
  host_port_to_expose        = "8081"
  container_port_to_expose   = "27017"
  instance_memory_allocation = "512"
  instance_count             = "1"
}

consul_definition = {
  docker_image_tag           = "492333042402.dkr.ecr.eu-west-1.amazonaws.com/tmp-pipeline/consul"
  name                       = "consul"
  context                    = "consul"
  host_port_to_expose        = "8500"                                                             #ALB
  container_port_to_expose   = "8500"                                                             #ALB
  instance_memory_allocation = "512"
  instance_count             = "1"
}

registrator_definition = {
  docker_image_tag           = "492333042402.dkr.ecr.eu-west-1.amazonaws.com/tmp-pipeline/registrator"
  name                       = "registrator"
  context                    = "registrator"
  host_port_to_expose        = ""                                                                      #Don't
  container_port_to_expose   = ""
  instance_memory_allocation = "512"
  instance_count             = "1"
}
