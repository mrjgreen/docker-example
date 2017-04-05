#!/bin/bash
set -e

apt-get install -yq nginx

cat << EOF > /etc/nginx/nginx.conf
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;

# Load dynamic modules. See /usr/share/nginx/README.fedora.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    server {
        listen 80;
        return 301 https://\$host\$request_uri;
    }

    server {

      listen 443;
      server_name "";

      ssl_certificate           /etc/nginx/conf.d/cert.crt;
      ssl_certificate_key       /etc/nginx/conf.d/cert.key;

      ssl on;
      ssl_session_cache  builtin:1000  shared:SSL:10m;
      ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
      ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
      ssl_prefer_server_ciphers on;

      access_log off;

      location / {
          proxy_pass         http://localhost:8080;

          proxy_set_header   Host             \$host;
          proxy_set_header   X-Real-IP        \$remote_addr;
          proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
          proxy_set_header   X-Forwarded-Proto http;
          proxy_max_temp_file_size 0;

          proxy_connect_timeout      150;
          proxy_send_timeout         100;
          proxy_read_timeout         100;

          proxy_buffer_size          8k;
          proxy_buffers              4 32k;
          proxy_busy_buffers_size    64k;
          proxy_temp_file_write_size 64k;

      }
    }
}
EOF

# Create some self-signed SSL certs
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/conf.d/cert.key -out /etc/nginx/conf.d/cert.crt \
    -subj "/C=UK/ST=Yorkshire/L=York/O=SampleArch/OU=DevOps/CN=example.com"

systemctl restart nginx
systemctl enable nginx
