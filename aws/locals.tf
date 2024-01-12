locals {
  OS = "debian" # ubuntu ou debian
  AdminUser = "admin" # ubuntu ou admin
  group = "b3-gr5" # Change this to your own group name
  tags = {
    Name = "${local.group}-${local.OS}"
  }
}
