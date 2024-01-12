locals {
  clientUser = "admin"
  timestamp = formatdate("DD-MMM-YYYY-hh-mm", timestamp())
}

variable "ami_prefix" {
  type    = string
  default = "tony-packer"
}

variable "ami_os_name" {
  type    = string
}

variable "ami_os_owner" {
  type    = string
}

variable "ami_os_kernel" {
  type    = string
}

variable "username" {
  type    = string
}

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "os" {
  tags                        = { "Name" = "b3-gr5", "OS" = "${var.ami_os_kernel}" }
  ami_name                    = "${var.ami_prefix}-${var.ami_os_kernel}-${local.timestamp}"
  instance_type               = "t3.micro"
  region                      = "eu-north-1"
  profile                     = "simplon"
  associate_public_ip_address = true
  source_ami_filter {
    filters = {
      name                = "${var.ami_os_name}"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["${var.ami_os_owner}"]
  }
  vpc_filter {
    filters = {
      "tag:Name"  = "b3-packer",
      "tag:Class" = "build",
      "isDefault" = "false"
    }
  }
  subnet_filter {
    filters = {
      "tag:Name"  = "b3-packer",
      "tag:Class" = "build",
      "tag:Type"  = "public"
    }
  }
  ssh_username = "${var.username}"
}

build {
  name    = "learn-packer"
  sources = ["source.amazon-ebs.os"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["export DEBIAN_FRONTEND=noninteractive", "apt-get update", "apt-get upgrade -y", "apt-get update", "apt-get -y install apache2 git unzip jq", "apt-get -y install certbot python3-certbot-apache"] 
    inline_shebang  = "/bin/sh -xe"
  }

  provisioner "file" {
    source      = "./index.html"
    destination = "/tmp/index.html"
  }

  provisioner "shell" {
    inline = ["sudo rm /var/www/html/index.html", "sudo mv /tmp/index.html /var/www/html/index.html"]
  }

  # provisioner "shell" {
  #   inline          = [
  #     "if [ $(id -u admin) ]; then sudo usermod -aG sudo '${local.clientUser}' else sudo adduser --gecos '' --disabled-password '${local.clientUser}' --group sudo fi",
  #     "KeyVarTmp=$(cat ../aws/ssh/technocorp.pub)", 
  #     "sudo mkdir '/home/'${local.clientUser}'/.ssh'",
  #     "echo $KeyVarTmp >> 'home/'${local.clientUser}'/.ssh/authorized_keys'",
  #     "sudo chmod 640 /home/${local.clientUser}/.ssh/authorized_keys",
  #     "sudo chmod 700 /home/${local.clientUser}/.ssh/",
  #     "sudo chown -R ${local.clientUser}:${local.clientUser} /home/${local.clientUser}/.ssh/",
  #     "echo \"${local.clientUser} ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers"
  #     ]
  # }

}
