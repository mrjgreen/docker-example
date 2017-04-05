variable "do_token" {
  description = "Your DO token"
}

variable "ssh_keys" {
  type = "list"
  description = "A list of SSH keys to add to the host"
}

variable "root_domain" {
  description = "A name of a domain or subdomain already link to the DO account"
  default = "joeg.co.uk"
}
