resource "azurerm_static_site" "frontend-app-site" {
  name                = "${var.prefix}-frontend-app-site"
  resource_group_name = azurerm_resource_group.terraform-new-infra-demo.name
  location            = "eastus2" # This has to be on a different server for azure reasons
  sku_tier            = "Free"
}