resource "azurerm_public_ip" "PublicIP_LB" {
  name                = "PublicIP_LB"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
