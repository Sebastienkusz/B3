variable "ami_prefix" {
  type    = string
  default = "tony-packer"
}

locals {
  timestamp = formatdate("DD-MMM-YYYY-hh-mm", timestamp())
}

variable "ami_os_name" {
  type    = string
}

variable "ami_os_owner" {
  type    = string
  default = "099720109477"
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
  tags                        = { "Name" = "b3-gr5", "OS" = "Ubuntu" }
  ami_name                    = "${var.ami_prefix}-${local.timestamp}"
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
  ssh_username = "ubuntu"
}

build {
  name    = "learn-packer"
  sources = ["source.amazon-ebs.os"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["apt-get update", "apt-get upgrade -y", "apt-get -y install nginx"]
    inline_shebang  = "/bin/sh -x"
  }

  provisioner "file" {
    source      = "./index.html"
    destination = "./index.html"
  }

  provisioner "shell" {
    inline = ["sudo rm /var/www/html/index.nginx-debian.html", "sudo mv ./index.html /var/www/html/index.nginx-debian.html"]
  }

}
