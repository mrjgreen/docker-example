#!/bin/bash
set -e

SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

IP_PUB_JENKINS_1=$(terraform output jenkins_1_public_ip)
IP_PUB_PROD_1=$(terraform output prod_1_public_ip)

CMD_TRUST="echo '{\"insecure-registries\": [\"prod-1.joeg.co.uk:5000\"]}' > /etc/docker/daemon.json"
CMD_RESTART="systemctl reload docker"
ssh $SSH_OPTS root@$IP_PUB_JENKINS_1 "$CMD_TRUST && $CMD_RESTART"
ssh $SSH_OPTS root@$IP_PUB_PROD_1 "$CMD_TRUST && $CMD_RESTART"
