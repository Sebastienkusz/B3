
# Create SSH key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_ssh_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.root}/ssh/${local.group}"
  file_permission = "0600"
}

# Upload SSH key to AWS
resource "aws_key_pair" "ec2" {
  key_name   = local.group
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Create a security group to allow SSH and HTTP(s) traffic
locals {
  group_ip_list = ["62.34.36.24/32", "83.195.211.184/32"] # Change this to your own IP
}

resource "aws_security_group" "ec2" {
  name        = "${local.group}-ec2"
  description = "Protect the EC2 instance"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "SSH from ${local.group} Public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.group_ip_list
  }
  ingress {
    description = "HTTP from ${local.group} Public IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.group_ip_list
  }
  ingress {
    description = "HTTPS from ${local.group} Public IP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.group_ip_list
  }
  egress {
    description = "Allow All outgoing Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["tony-packer-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "OS"
    values = ["${local.OS}"]
  }
  owners = ["637423211400"]
}

resource "aws_instance" "tony" {
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.ec2.key_name
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  volume_tags            = local.tags
  associate_public_ip_address = true
}
