data "template_cloudinit_config" "jenkins" {

  base64_encode = false
  gzip = false

  part {
    content_type = "text/x-shellscript"
    content      = "${file("user_data/basic.sh")}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${file("user_data/docker.sh")}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${file("user_data/jenkins.sh")}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${file("user_data/nginx.sh")}"
  }
}


resource "digitalocean_droplet" "jenkins-1" {
  image  = "ubuntu-16-04-x64"
  name   = "jenkins-1"
  region = "lon1"
  size   = "1gb"
  private_networking = true
  ssh_keys = "${var.ssh_keys}"
  user_data = "${data.template_cloudinit_config.jenkins.rendered}"
}

output "jenkins_1_public_ip" {
  value = "${digitalocean_droplet.jenkins-1.ipv4_address}"
}
/*output "jenkins_1_private_ip" {
  value = "${digitalocean_droplet.jenkins-1.ipv4_address_private}"
}*/

resource "digitalocean_record" "jenkins-1" {
  domain = "${var.root_domain}"
  type   = "A"
  name   = "jenkins"
  value  = "${digitalocean_droplet.jenkins-1.ipv4_address}"
}

output "jenkins_host" {
  value = "${digitalocean_record.jenkins-1.fqdn}"
}
