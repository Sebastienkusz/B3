terraform {
  backend "azurerm" {
    resource_group_name  = "b3-gr5"
    storage_account_name = "b3gr5tfstate"
    container_name       = "tfstate"
    key                  = "b3-gr5/terraform.tfstate"
  }
}