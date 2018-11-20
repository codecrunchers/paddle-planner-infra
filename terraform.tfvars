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

pp_webapp_definition = {
  docker_image_tag           = "507358225127.dkr.ecr.us-west-1.amazonaws.com/paddle-planner-webapp:latest"
  name                       = "webapp"
  context                    = "app"
  host_port_to_expose        = "8080"
  container_port_to_expose   = "4040"
  instance_memory_allocation = "256"
  instance_count             = "1"
  health_ckeck_uri           = "/auth/login"
}

mongo_definition = {
  docker_image_tag           = "507358225127.dkr.ecr.us-west-1.amazonaws.com/paddle-planner-mongo:latest"
  name                       = "mongo"
  context                    = "mongo"
  host_port_to_expose        = "27017"
  container_port_to_expose   = "27017"
  instance_memory_allocation = "256"
  instance_count             = "1"
}
