
resource "azurerm_resource_group" "ds24rg" {
  name     = "ds24-resources"
  location = "West Europe"
}

resource "azurerm_log_analytics_workspace" "ds24logspace" {
  name                = "ds24-logspace-01"
  location            = azurerm_resource_group.ds24rg.location
  resource_group_name = azurerm_resource_group.ds24rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
