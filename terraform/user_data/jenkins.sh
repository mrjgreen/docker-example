#!/bin/bash
set -e

apt-get install -yq default-jre default-jdk

wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list

apt-get update -q
apt-get install -yq jenkins

cat << EOF > /srv/install-jenkins-plugins.sh
#!/bin/bash

set -e

if [ \$# -lt 2 ]; then
  echo "USAGE: \$0 folder plugin1 plugin2 ..."
  exit 1
fi

plugin_dir=\$1
shift

file_owner=jenkins.jenkins

mkdir -p \$plugin_dir

installPlugin() {
  if [ -f \${plugin_dir}/\${1}.hpi -o -f \${plugin_dir}/\${1}.jpi ]; then
    if [ "\$2" == "1" ]; then
      return 1
    fi
    echo "Skipped: \$1 (already installed)"
    return 0
  else
    echo "Installing: \$1"
    curl -L --silent --output \${plugin_dir}/\${1}.hpi  https://updates.jenkins-ci.org/latest/\${1}.hpi
    return 0
  fi
}

for plugin in \$*
do
    installPlugin "\$plugin"
done

changed=1
maxloops=100

while [ "\$changed"  == "1" ]; do
  echo "Check for missing dependecies ..."
  if  [ \$maxloops -lt 1 ] ; then
    echo "Max loop count reached - probably a bug in this script: \$0"
    exit 1
  fi
  ((maxloops--))
  changed=0
  for f in \${plugin_dir}/*.hpi ; do
    deps=\$( unzip -p \${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;\$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print \$2 }' | tr ',' '\n' | awk -F ':' '{ print \$1 }' | tr '\n' ' ' )
    for plugin in \$deps; do
      installPlugin "\$plugin" 1 && changed=1
    done
  done
done

echo "fixing permissions"

chown \${file_owner} \${plugin_dir} -R

echo "all done"
EOF

chmod a+x /srv/install-jenkins-plugins.sh

/srv/install-jenkins-plugins.sh /var/lib/jenkins/plugins git blueocean delivery-pipeline-plugin build-timeout cloudbees-folder copyartifact git github matrix-auth parameterized-trigger ssh ssh-agent timestamper ws-cleanup

# So jenkins can run docker commands
usermod -a -G docker jenkins

systemctl restart jenkins
systemctl enable jenkins
