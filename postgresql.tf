
# Azure PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "example" {
  name                   = "postgresql-flex-server-01"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  administrator_login    = "psqladminun"
  administrator_password = "H@Sh1CoR3!"
  sku_name               = "B_Standard_B1ms"
  version                = "13"
  storage_mb             = 32768
  zone                   = "1"

  authentication {
    password_auth_enabled = true
  }

  public_network_access_enabled = true
}


resource "azurerm_postgresql_flexible_server_database" "exampledb" {
  name      = "exampledb"
  server_id = azurerm_postgresql_flexible_server.example.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}


# Allow access to PostgreSQL on port 5432 from anywhere (for demo/testing; restrict in production)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "allow-all"
  server_id        = azurerm_postgresql_flexible_server.example.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

# Allow access to PostgreSQL from subnet A (10.0.30.0/24)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_subnet_a" {
  name             = "allow-subnet-a"
  server_id        = azurerm_postgresql_flexible_server.example.id
  start_ip_address = "10.0.30.0"
  end_ip_address   = "10.0.30.255"
}

# Allow access to PostgreSQL from subnet B (10.0.40.0/24)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_subnet_b" {
  name             = "allow-subnet-b"
  server_id        = azurerm_postgresql_flexible_server.example.id
  start_ip_address = "10.0.40.0"
  end_ip_address   = "10.0.40.255"
}
