packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/digitalocean"
    }
  }
}

variable "api_token" {
  type    = string
  default = "${env("DIGITALOCEAN_TOKEN")}"
}

source "digitalocean" "base_image" {
  api_token     = "${var.api_token}"
  image         = "ubuntu-22-04-x64"
  size          = "512mb"
  region        = "nyc3"
  ssh_username  = "root"
  snapshot_name = "base-{{isotime}}"
}

build {
  sources = [
    "source.digitalocean.base_image"
  ]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "ansible" {
    playbook_file        = "main.yml"
    galaxy_file          = "requirements.yml"
    galaxy_force_install = true
    extra_arguments = [
      "--vault-password-file", "vault_password.sh"
    ]
  }
}
