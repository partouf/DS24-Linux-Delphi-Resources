data "azurerm_subscription" "primary" {
}

resource "azurerm_role_definition" "ds24restartuserroledef" {
  name  = "ds24restartuserroledef"
  scope = data.azurerm_subscription.primary.id

  permissions {
    actions = [
      "Microsoft.App/containerApps/*/read",
      "Microsoft.App/containerApps/read",
      "microsoft.app/containerapps/revisions/restart/action"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id
  ]
}
