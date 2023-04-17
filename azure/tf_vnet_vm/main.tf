########################################################################################
# Create a resource group                                                              #
# Create a VNET with 3 subnets and a network security group                            #
# Create a NetworkSecurityGroup with 3 rules: SSH, HTTP, HTTPS                         #
# Uses Terraform Azure vnet module                                                     #
# https://registry.terraform.io/modules/Azure/vnet/azurerm/latest                      #
########################################################################################

# Create resource group
resource "azurerm_resource_group" "rg_cloudlab" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location
}

# Create a network security group 
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.project}-${var.environment}"
  location            = azurerm_resource_group.rg_cloudlab.location
  resource_group_name = azurerm_resource_group.rg_cloudlab.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "122.60.164.155/32" # my IP address
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

module "vnet" {
  source              = "azure/vnet/azurerm"
  version             = "4.0.0"
  resource_group_name = azurerm_resource_group.rg_cloudlab.name
  vnet_name           = "vnet-${var.project}-${var.environment}"
  use_for_each        = var.use_for_each
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  vnet_location       = var.location
  nsg_ids = {
    subnet1 = azurerm_network_security_group.nsg.id
    subnet2 = azurerm_network_security_group.nsg.id
    subnet3 = azurerm_network_security_group.nsg.id
  }
  tags = {
    environment = "dev"
    owner       = "aswathi@cloudlab"
    project     = "cloudlab"
  }

}