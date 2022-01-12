terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.14.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-1"
  access_key = var.aws_a_key
  secret_key = var.aws_s_key
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "default" {
  name       = "my_key"
  public_key = var.my_key
}

resource "digitalocean_droplet" "vm" {
  count    = length(var.domain)
  image    = "ubuntu-20-04-x64"
  name     = element(var.domain, count.index)
  region   = "nyc1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  tags     = ["devops", "skozyrev95_at_gmail_com"]
}

locals {
  ipadr = digitalocean_droplet.vm.*.ipv4_address
}

data "aws_route53_zone" "zid" {
  name = "you_hosted_zone"
}

resource "aws_route53_record" "dnsaws5" {
  count   = length(var.domain)
  zone_id = data.aws_route53_zone.zid.zone_id
  name    = "${element(var.domain, count.index)}.${data.aws_route53_zone.zid.name}"
  type    = "A"
  ttl     = "300"
  records = [element(local.ipadr, count.index)]
}
