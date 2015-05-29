from registry:2

env CACHE_REDIS_HOST 127.0.0.1
env CACHE_REDIS_PORT 6379
env CACHE_LRU_REDIS_HOST 127.0.0.1
env CACHE_LRU_REDIS_PORT 6379

expose 80

run apt-get update
run apt-get -y upgrade
run apt-get install -y apache2-utils supervisor python-setuptools nginx redis-server libssl-dev wget curl

run rm /etc/rc*.d/*nginx

# Install confd
ENV CONFD_VERSION 0.9.0
RUN \
  curl -L https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VERSION/confd-$CONFD_VERSION-linux-amd64 -o /usr/local/bin/confd && \
  chmod 0755 /usr/local/bin/confd

ADD registry.users.tmpl /etc/confd/templates/
ADD registry.users.toml /etc/confd/conf.d/
add run.sh /usr/local/bin/run
cmd ["/usr/local/bin/run"]
