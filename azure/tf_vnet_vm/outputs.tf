########################################################################################
# Output values here                                                                   #
########################################################################################

# Output resource group name
output "resource_group_name" {
  value = azurerm_resource_group.rg_cloudlab.name
}

# Output public IP address
output "public_ip_address" {
  value = azurerm_linux_virtual_machine.vm-test.public_ip_address
}

# Output SSH key
output "tls-private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}
