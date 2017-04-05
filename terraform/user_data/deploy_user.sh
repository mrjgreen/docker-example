#!/bin/bash
set -e
###############
# Deploy User
###############

# Create a deploy user and add them to the docker group. Set the user's home to /srv/deploy
useradd deploy || true
mkdir -p /srv/deploy
usermod -m -d /srv/deploy -aG docker deploy
# Add a deploy key
mkdir -p /srv/deploy/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwS4qGGXwHEPqUO22oq3j8nX0bClebJTwUfSEBEWTlgikKlCf4WVzKQwcSumGucSZbZRH3BqgMtRJ1Zkgneo5KbekNhoW1/QBmCABmPW+KgJpoi/LmeOGzUzsmG91mAK4z/SwgGczq0tvlQUIIjVEqjGUyhGnCSG8OWvCNl8AFfcdrsVhyAQKf7wqnTeuVBOFQOIZMOCftnaaK4mKAMwJmncYgWeS6n/QaeOIhFbIAmheZeXzSClnzWgeZixX6rRiPg0IGjv1LESa7cjH7FOj5J+lS8WjNOgPl6LoIix0cECSsG9UWQ5Ge2LJyT/dtfQa3A1QgoWuRH6zOwJbNfVKZ joegreen@Joes-MacBook-Pro.local" > /srv/deploy/.ssh/authorized_keys
chmod 0600 /srv/deploy/.ssh/authorized_keys
# Change ownership of all directories
chown -R deploy /srv/deploy
