locals {
  OS = "ubuntu" # ubuntu ou debian
  group = "b3-gr5" # Change this to your own group name
  tags = {
    Name = local.group
  }
}
