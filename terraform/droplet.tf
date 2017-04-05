data "template_cloudinit_config" "prod" {

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
    content      = "${file("user_data/registry.sh")}"
  }
}

resource "digitalocean_droplet" "prod-1" {
  image  = "ubuntu-16-04-x64"
  name   = "prod-1"
  region = "lon1"
  size   = "512mb"
  private_networking = true
  ssh_keys = "${var.ssh_keys}"
  user_data = "${data.template_cloudinit_config.prod.rendered}"
}

output "prod_1_public_ip" {
  value = "${digitalocean_droplet.prod-1.ipv4_address}"
}
output "prod_1_private_ip" {
  value = "${digitalocean_droplet.prod-1.ipv4_address_private}"
}

resource "digitalocean_record" "prod-1" {
  domain = "${var.root_domain}"
  type   = "A"
  name   = "prod-1"
  value  = "${digitalocean_droplet.prod-1.ipv4_address}"
}

output "prod_host" {
  value = "${digitalocean_record.prod-1.fqdn}"
}
