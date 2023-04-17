########################################################################################
# Create a public IP address                                                           #
# Create a network interface card                                                      #
# Assign public IP with NIC                                                            #
# Add NSG to network interface card                                                    #
# Create a storage account for boot diaganostics                                       #
# Create tls key pair for SSH                                                          #
# Create a Linux virtual machine                                                       #
########################################################################################

# Create a public IP address
resource "azurerm_public_ip" "public_ip" {
  name                = "public_ip-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg_cloudlab.name
  location            = azurerm_resource_group.rg_cloudlab.location
  allocation_method   = "Static"
}

# Create a network interface card
resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg_cloudlab.name
  location            = azurerm_resource_group.rg_cloudlab.location
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = lookup(module.vnet.vnet_subnets_name_id, "subnet1")
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Associate network security group to network interface card
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Generate randon id for diagnostics storage account
resource "random_id" "random_id" {
  byte_length = 8
}

# Create a diagnostics storage account
resource "azurerm_storage_account" "diag_sa" {
  name                     = "diag${random_id.random_id.hex}"
  resource_group_name      = azurerm_resource_group.rg_cloudlab.name
  location                 = azurerm_resource_group.rg_cloudlab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

# Create an SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "vm-test" {
  name                  = "vm-${var.project}-${var.environment}"
  resource_group_name   = azurerm_resource_group.rg_cloudlab.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"
  location              = var.location
  os_disk {
    name                 = "osdisk-${var.project}-${var.environment}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  computer_name                   = "vm-${var.project}-${var.environment}"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh_key.public_key_openssh
  }
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diag_sa.primary_blob_endpoint
  }


}


