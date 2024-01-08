# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}
