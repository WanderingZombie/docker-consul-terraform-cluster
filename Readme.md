# consul-master

Build a consul cluster on docker and run with terraform

## prerequisites

1. Install and configure [docker](http://docs.docker.com/linux/started/)
2. Install terraform from [Hashicorp](https://terraform.io/)

## building

Build the consul docker image using the following command

```
sudo docker build -t maguec/consul-master .
```

## running

Edit `terraform/variables.tf` to define the connection to docker and the path for consul to use as persistent storage.

```
# destroy the directory and re-create - stale data will cause 500 errors
sudo rm -rf /data/docker/consul1
sudo mkdir -p /data/docker/consul1

cd terraform

# view what would happen
sudo terraform plan

# apply the configuration
sudo terraform apply

# due to the spinup time you may have to run plan and apply twice
```

### issues on Windows

If the `consul1` instance fails to build

```
> sudo terraform apply -auto-approve
docker_image.consul-master: Creating...
docker_image.consul-master: Creation complete after 0s [id=sha256:5632589661185b75660b6a48391c0b302d061cf1cd0d8acf5ec5ebc4a3141dc4maguec/consul-master]
docker_container.consul-master: Creating...
docker_container.consul-master: Still creating... [10s elapsed]

Error: Container cae808e989682bdc5d1b7f3e89f941ffc320248f03a3162442fbb7b9fb62a559 failed to be in running state

  on terraform.tf line 17, in resource "docker_container" "consul-master":
  17: resource "docker_container" "consul-master" {
```

this is most likely due to a line-ending issue with `scripts/run-consul-server` which can be resolved with 

```bash
sudo terraform destroy -auto-approve
git config --global core.autocrlf input
git checkout scripts/*
```

Then start again with building the container

## using

To connect to the consul web-ui

[http://localhost:8500/ui/](http://localhost:8500/ui/)
