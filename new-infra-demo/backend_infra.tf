resource "azurerm_postgresql_flexible_server" "new-infra-demo-postgresql-flexible-server" {
  name                          = "${var.prefix}-postgresql-flexible-server"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.terraform-new-infra-demo.name
  version                       = "14"
  sku_name                      = "B_Standard_B1ms"
  delegated_subnet_id           = azurerm_subnet.new-infra-demo-subnet-db.id
  private_dns_zone_id           = azurerm_private_dns_zone.db-dns-zone.id
  storage_mb                    = 32768
  administrator_login           = "psqladmin"
  administrator_password        = "$changeme1" # THIS IS FOR DEMO PURPOSES - we would have to use something like the Keeper integration in production
  zone                          = "2"
  depends_on                    = [azurerm_private_dns_zone_virtual_network_link.db-dns-zone-link]
}

resource "azurerm_postgresql_flexible_server_database" "new-infra-demo-postgresql-db" {
  name                = "${var.prefix}-postgresql-db"
  server_id           = azurerm_postgresql_flexible_server.new-infra-demo-postgresql-flexible-server.id
  collation           = "en_US.utf8"
  charset             = "utf8"
}

resource "azurerm_service_plan" "django-server-demo-service-plan" {
  name                = "service-plan-pst-tf-demo"
  resource_group_name = azurerm_resource_group.terraform-new-infra-demo.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"
  worker_count        = var.django_server_worker_count
}

resource "azurerm_linux_web_app" "django-server-demo-service-plan-app" {
  name                      = "web-app-pst-tf-demo-1"
  resource_group_name       = azurerm_resource_group.terraform-new-infra-demo.name
  location                  = var.location
  service_plan_id           = azurerm_service_plan.django-server-demo-service-plan.id
  virtual_network_subnet_id = azurerm_subnet.new-infra-demo-subnet-django.id

  site_config {
    application_stack {
        python_version      = "3.9"
    }
  }
}