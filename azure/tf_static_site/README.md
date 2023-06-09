# Static Website Hosting in Azure Storage - Terraform Module

This is a Terraform module for provisioning a static website hosted on storage container on Azure.  Storage container can be used to serve static content, such as HTML, CSS, JavaScript, and image files  directly from a storage container named $web. This module is built in accordance with the Microsoft documentation available in this [link](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website). This module will provision a  resource group ( optionally with sub module) create a storage container and add a sample index.html page.

## About This Module

This module provisions a static website hosted out of a storage container , in accordance with the [Microsoft documentation](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website) . Users can optionally create a resource group using the `resource_group` sub module or use an existing resource group. Usage samples are available in the 'examples' directory.

The following resources are created by this code:

- **Storage Account**: A storage account is created to host the static website. The name of the storage account is based on the `project_name` and `environment` variables and has the format `sa<project_name><environment>`. The storage account is created in the resource group specified by the `resource_group_name` variable and in the location specified by the `location` variable. The storage account tier, replication type, and kind are determined by the `account_tier`, `account_replication_type`, and `account_kind` variables, respectively. HTTPS traffic is enabled or disabled based on the value of the `enable_https_traffic_only` variable. The minimum TLS version is set to the value of the `min_tls_version` variable. The storage account is also tagged with the tags specified in the `tags` variable.

- **Static Website**: A static website is created in the storage account. The index document is set to `index.html` and the error 404 document is set to `404.html`.

- **Blobs**: The HTML files in the directory specified by the `html_files_dir` variable are uploaded to the `$web` container in the storage account. The content type of each uploaded blob is set to `text/html`.


## How to Use This Module

- Create a Terraform configuration that pulls in the module and specifies values of the required variables:

To use this code, you'll need to provide values for the following variables:

- `project_name`: The name of the project.
- `environment`: The environment (e.g., development, staging, production).
- `resource_group_name`: The name of the resource group where the storage account will be created.
- `location`: The Azure location where the resources will be created.
- `account_tier`: The tier of the storage account (e.g., Standard).
- `account_replication_type`: The replication type of the storage account (e.g., LRS).
- `account_kind`: The kind of the storage account (e.g., StorageV2).
- `enable_https_traffic_only`: Whether to allow only HTTPS traffic to the storage account.
- `min_tls_version`: The minimum TLS version supported by the storage account.
- `tags`: A map of tags to apply to the resources.
- `html_files_dir`: The path to the directory containing the HTML files to upload.

```
module "resource_group_dev" {
  source       = "./modules/resource_group"
  project_name = local.project_name
  environment  = local.environment
  location     = local.location
  tags         = local.tags
}

module "storage_account_dev" {
  source                    = "./modules/storage_account"
  project_name              = local.project_name
  environment               = local.environment
  location                  = local.location
  resource_group_name       = module.resource_group_dev.resource_group_name
  tags                      = local.tags
  account_tier              = local.account_tier
  account_replication_type  = local.account_replication_type
  account_kind              = local.account_kind
  enable_https_traffic_only = local.enable_https_traffic_only
  min_tls_version           = local.min_tls_version
  html_files_dir            = local.html_files_dir
}
```

Notes: 
1. Creating a resource group is optional. If you have an existing resource group, you can pass the name in 'resource_group_name' variable

> Run `terraform init` and `terraform apply`

## License

This code is released under the MIT License 2.0. Please see [LICENSE](https://github.com/aswathicloudlab/cloud_projects/blob/main/azure/tf_static_site/LICENSE) for more details.
