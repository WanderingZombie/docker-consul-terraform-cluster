######################################################################################
#               Start up the master with ports and volumes
######################################################################################
provider "docker" {
  version = "~> 2.6"
  host = var.docker_connection
}

resource "docker_image" "consul-master" {
  name = "maguec/consul-master"
  keep_locally = true  # true = keep image if we do "terraform destroy"
}

resource "docker_container" "consul-master" {
  name = "consul1"
  image = docker_image.consul-master.latest
  command = [
    "-server",
    "-bootstrap",  # self-elect as the Raft leader
    "-node=consul1",
    "-ui",
  ]
  ports {
    internal = 8300
    external = 8300
  }
  ports {
    internal = 8301
    external = 8301
  }
  ports {
    internal = 8301
    external = 8301
    protocol = "udp"
  }
  ports {
    internal = 8302
    external = 8302
    protocol = "udp"
  }
  ports {
    internal = 8400
    external = 8400
  }
  ports {
    internal = 8500
    external = 8500
  }
  ports {
    internal = 53
    external = 8600
    protocol = "udp"
  }
  volumes {
    container_path = "/data"
    host_path = var.consul_persistent_storage_path
  }
}
#####################################################################################
resource "docker_container" "consul2" {
  name = "consul2"
  image = docker_image.consul-master.latest
  command = [
    "-server",
    "-join=${docker_container.consul-master.ip_address}",
    "-node=consul2",
    "-ui",
  ]
}
######################################################################################
resource "docker_container" "consul3" {
  name = "consul3"
  image = docker_image.consul-master.latest
  command = [
    "-server",
    "-join=${docker_container.consul-master.ip_address}",
    "-node=consul3",
    "-ui",
  ]
}
######################################################################################
# Set an example key in the key/value store
provider "consul" {
  address = "localhost:8500"
  datacenter = "docker"
  scheme = "http"
  version = "~> 2.9.0"
}

# if this doesn't work first time, run plan and apply again
resource "consul_keys" "example_key" {
  datacenter = "docker"
  key {
    path = "settings/global/speed/ludicrous"
    value = "on"
  }
  # wait for all 3 containers to complete, but doesn't ensure that a leader has been elected
  depends_on = [docker_container.consul-master, docker_container.consul2, docker_container.consul3]
}
