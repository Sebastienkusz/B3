variable "ami_prefix" {
  type    = string
  default = "tony-packer"
}

locals {
  timestamp = formatdate("DD-MMM-YYYY-hh-mm", timestamp())
}