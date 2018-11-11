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
