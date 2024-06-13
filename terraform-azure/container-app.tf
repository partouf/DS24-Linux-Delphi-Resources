
resource "azurerm_container_app_environment" "ds24appenv" {
  name                       = "ds24-app-env"
  location                   = azurerm_resource_group.ds24rg.location
  resource_group_name        = azurerm_resource_group.ds24rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.ds24logspace.id
}

resource "azurerm_container_app" "ds24containerapp" {
  name                         = "ds24-container-app"
  container_app_environment_id = azurerm_container_app_environment.ds24appenv.id
  resource_group_name          = azurerm_resource_group.ds24rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "ds24app"
      image  = "ds24containerreg.azurecr.io/ds24-app-docker:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name        = "SYSLOG_HOST"
        secret_name = "sysloghost"
      }
      env {
        name        = "SYSLOG_PORT"
        secret_name = "syslogport"
      }
    }

    min_replicas = 0
    max_replicas = 5

    http_scale_rule {
      name                = "httpscale"
      concurrent_requests = "2"
    }
  }

  registry {
    server               = "ds24containerreg.azurecr.io"
    username             = azurerm_container_registry_token.image-pull-scope-token.name
    password_secret_name = "password"
  }

  secret {
    name  = "password"
    value = azurerm_container_registry_token_password.image-pull-scope-token.password1[0].value
  }

  secret {
    name  = "sysloghost"
    value = "logs.papertrailapp.com"
  }

  secret {
    name  = "syslogport"
    value = var.syslog_port
  }

  ingress {
    external_enabled = true
    target_port      = 80

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
