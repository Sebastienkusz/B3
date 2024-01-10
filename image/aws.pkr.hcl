packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  tags                        = { "Name" = "b3-gr5" }
  ami_name                    = "tony-packer-linux-aws"
  instance_type               = "t3.micro"
  region                      = "eu-north-1"
  access_key                  = "AKIAZI2LCKOEHKJYURNM"
  secret_key                  = "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"
  associate_public_ip_address = true
  force_deregister            = true
  force_delete_snapshot       = true
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
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
  sources = ["source.amazon-ebs.ubuntu"]

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
