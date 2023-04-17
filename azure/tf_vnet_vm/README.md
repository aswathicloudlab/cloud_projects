# Cloud projects
## IaC using Terraform and CI/CD
Aswathi Shiju - [LinkedIn profile](https://www.linkedin.com/in/aswathi-shiju/)

This repository contains Terraform based infrastructure of code experiments I tried out during my cloud learning journey. As they say , learning is for a life time :) 

If you would like to try out this code , please feel free to clone this repo. In case you have any questions please send a message in LinkedIn or raise a github issue. 

## Azure Create a VNET and Virtual Machine

The .tf files in  cloud_projects/azure/tf_vnet_vm/ contains the Terraform code to launch a virtual machine inside a VNET.
 
 VNET is created using Azure terraform VNET module available from [here](https://registry.terraform.io/modules/Azure/vnet/azurerm/latest)
### Create VNET
Sample VNET module code is as below, address space 10.0.0.0/16 is sub divided into 3 subnets and network security group is associated with the subnets.

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

### Create Linux Virtual Machine
The tf file cloud_projects/azure/tf_vnet_vm/r_vm.tf contains the Terraform code create a Linux virtual machine. 

It contains the following steps

- Create a public IP address 
- Create a network interface card 
- Assign public IP with NIC 
-  Add NSG to network interface card 
- Create a storage account for boot diagnostics 
- Create tls key pair for SSH 
- Create a Linux virtual machine

### Export tls-private_key value from Terraform state file
An output block is defined in outputs.tf file to output the value of SSH private key.

    output  "tls-private_key" {
    value  =  tls_private_key.ssh_key.private_key_pem
    sensitive  =  true
    }
Since it is marked as sensitive , terraform wont print the values in console by default.

To export the private key value from the state file use the following command

    terraform output -raw tls-private_key  > private_key.pem

### Install Terraform in the developer laptop
To run Terraform code we need to install Terraform application on the developer laptop first. Detailed instructions matching your operating system is available from this [link](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
 
 ### Execute Terraform code

Once Terraform is installed in the laptop , we can validate the script with below command and then if there are no errors proceed to code formatting with terraform fmt command.

    cd to the directory where main.tf is saved
    terraform validate .
    terraform fmt .

Now proceed to terraform plan

    terraform plan

Finally apply the code to create AWS resources

    terraform apply

### Install azure cli 

Azure cli tool need to be installed on the developer machine to connect with the azure subscription. Detailed step matching your version of operating system is available from this [link](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build)


