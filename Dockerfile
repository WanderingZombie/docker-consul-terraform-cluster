########################################################################
#		Run the Consul server and web ui
########################################################################
FROM            ubuntu:20.04
MAINTAINER      chris.mague@shokunin.co

#
RUN apt-get update && apt-get install -y unzip

# Install the consul binary and web ui

ADD https://releases.hashicorp.com/consul/1.8.3/consul_1.8.3_linux_amd64.zip /tmp/consul.zip
RUN cd /bin && unzip /tmp/consul.zip && chmod +x /bin/consul

# Add consul configs
ADD ./config /config/
ONBUILD ADD ./config /config/

# runscript that takes arguments!
ADD ./scripts/run-consul-server /bin/run-consul-server
RUN chmod +x /bin/run-consul-server

# Create a mount point
VOLUME ["/data"]

# Expose consul ports
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp

ENTRYPOINT ["/bin/run-consul-server"]
