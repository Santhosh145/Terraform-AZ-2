resource "azurerm_lb" "frontend_lb" {
  name                = "FrontendStandardLB"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicLBFrontEnd"
    public_ip_address_id = azurerm_public_ip.PublicIP_LB.id
  }
}

resource "azurerm_lb_backend_address_pool" "frontend_lb_backend" {
  name            = "FrontendLBBackendPool"
  loadbalancer_id = azurerm_lb.frontend_lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "publicvm_lb_assoc" {
  network_interface_id    = azurerm_network_interface.PublicNIC.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.frontend_lb_backend.id
}

resource "azurerm_lb_probe" "frontend_lb_probe" {
  name            = "FrontendLBProbe"
  loadbalancer_id = azurerm_lb.frontend_lb.id
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "frontend_lb_rule" {
  name                           = "FrontendLBRule"
  loadbalancer_id                = azurerm_lb.frontend_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.frontend_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.frontend_lb_backend.id]
  probe_id                       = azurerm_lb_probe.frontend_lb_probe.id
}
