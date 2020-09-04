# define how to connect to docker
variable "docker_connection" {
  type    = string
  #default = "unix:///var/run/docker.sock"       # linux / wsl2
  #default = "tcp://127.0.0.1:2375/"             # windows without TLS
  default = "npipe:////.//pipe//docker_engine"  # windows with TLS
}

# define consul persistent storage path
variable "consul_persistent_storage_path" {
  type    = string
  default = "C:\\Users\\jp_ni\\data\\docker\\consul1"   # e.g. windows
  #default = "/data/docker/consul1"                      # e.g. linux
}
