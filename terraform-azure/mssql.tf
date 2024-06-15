
locals {
  mssql_db_admin_password = "nb#E\\OSj[9O/mck1,"
}

resource "azurerm_mssql_server" "ds24mssql" {
  name                         = "ds24-mssql"
  resource_group_name          = azurerm_resource_group.ds24rg.name
  location                     = azurerm_resource_group.ds24rg.location
  version                      = "12.0"
  administrator_login          = "ds24admin"
  administrator_login_password = local.mssql_db_admin_password
}

# note: this opens up mssql for all of Azure, not just your account - so don't share the DB details + password like I have here
resource "azurerm_mssql_firewall_rule" "ds24mssqlfw" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.ds24mssql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_database" "ds24mssqldb" {
  name           = "ds24-mssql-db"
  server_id      = azurerm_mssql_server.ds24mssql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "BasePrice"
  sku_name       = "Basic" # `az sql db list-editions -l westeurope -o table`
  zone_redundant = false

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}
