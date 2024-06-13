locals {
  docker-repo-name     = "ds24-app-docker"
  docker-repo-readperm = "repositories/ds24-app-docker/content/read"
}


resource "azurerm_container_registry" "ds24cr" {
  name                = "ds24containerreg"
  resource_group_name = azurerm_resource_group.ds24rg.name
  location            = azurerm_resource_group.ds24rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_registry_scope_map" "image-pull-scope" {
  name                    = "image-pull-scope"
  container_registry_name = azurerm_container_registry.ds24cr.name
  resource_group_name     = azurerm_resource_group.ds24rg.name
  actions = [
    local.docker-repo-readperm
  ]
}

resource "azurerm_container_registry_token" "image-pull-scope-token" {
  name                    = "image-pull-scope-token"
  container_registry_name = azurerm_container_registry.ds24cr.name
  resource_group_name     = azurerm_resource_group.ds24rg.name
  scope_map_id            = azurerm_container_registry_scope_map.image-pull-scope.id
}

resource "azurerm_container_registry_token_password" "image-pull-scope-token" {
  container_registry_token_id = azurerm_container_registry_token.image-pull-scope-token.id

  password1 {
    # never expire
  }
}
