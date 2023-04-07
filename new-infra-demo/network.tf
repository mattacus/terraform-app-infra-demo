
resource "azurerm_virtual_network" "new-infra-demo-network" {
  name                = "${var.prefix}-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-new-infra-demo.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "new-infra-demo-subnet-db" {
  name                 = "${var.prefix}-subnet-db"
  resource_group_name  = azurerm_resource_group.terraform-new-infra-demo.name
  virtual_network_name = azurerm_virtual_network.new-infra-demo-network.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "new-infra-demo-subnet-django" {
  name                 = "${var.prefix}-subnet-django"
  resource_group_name  = azurerm_resource_group.terraform-new-infra-demo.name
  virtual_network_name = azurerm_virtual_network.new-infra-demo-network.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "sf"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_private_dns_zone" "db-dns-zone" {
  name                = "privatedemo.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.terraform-new-infra-demo.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "db-dns-zone-link" {
  name                  = "privatedemo.azurewebsites.net"
  private_dns_zone_name = azurerm_private_dns_zone.db-dns-zone.name
  virtual_network_id    = azurerm_virtual_network.new-infra-demo-network.id
  resource_group_name   = azurerm_resource_group.terraform-new-infra-demo.name
}