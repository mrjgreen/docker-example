#!/bin/bash
set -e

###############
# Setup Registry
###############

mkdir -p /srv/{data,certs,auth}

#sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /srv/certs/registry.key -out /srv/certs/registry.crt \
#    -subj "/C=UK/ST=Yorkshire/L=York/O=SampleArch/OU=DevOps/CN=example.com"

#apt-get install -yq apache2-utils
#htpasswd -Bbn docker dkwu4oqg1uhrhv882hu8ckhofsgsk > /srv/auth/htpasswd

cat << EOF > /srv/docker-compose.yml
registry:
  restart: always
  image: registry:2
  ports:
    - 5000:5000
  volumes:
    - /srv/data:/var/lib/registry
EOF

docker-compose -f /srv/docker-compose.yml up -d
