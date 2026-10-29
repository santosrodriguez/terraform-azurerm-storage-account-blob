# Azure Storage Account Blob Terraform Module

## Introduction
Deploy secure, production-ready Azure Storage Accounts with optional Private Endpoint integration using Terraform.

## Usage

```hcl
module "sa" {
  source                             = "caresource.pe.jfrog.io/shared-tfmodules-internal__storage/storage-account-blob/azurerm"
  version                            = "1.0.0"
  storage_account_name               = "name"
  resource_group_name                = azurerm_resource_group.rg.name
  storage_private_endpoint_subnet_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/virtualNetworks/.../subnets/subnet"
  tags = {
    Environment : "DEV"
  }
}

```

## Inputs

| Name                                | Type           | Description                                       | Default    |
|--------------------------------------|----------------|---------------------------------------------------|------------|
| storage_account_name                 | string         | The name of the storage account                   | n/a        |
| resource_group_name                  | string         | Resource group name                               | n/a        |
| location                            | string         | Azure region                                      | "eastus"        |
| account_kind                        | string         | Storage account kind                              | "StorageV2"|
| account_tier                        | string         | Storage account tier                              | "Standard" |
| account_replication_type             | string         | Replication type                                  | "LRS"      |
| https_traffic_only_enabled          | bool           | Force HTTPS                                       | true       |
| min_tls_version                     | string         | Min TLS version                                   | "TLS1_2"   |
| storage_account_public_network_access_enabled | bool | Enable public network access                      | false      |
| tags                                | map(string)    | Resource tags                                     | {}         |
| storage_private_endpoint_subnet_id   | string         | Private endpoint subnet resource ID                | ""         |
| private_dns_zone_group_name          | string         | Private DNS zone group name                        | "default"         |
| private_dns_zone_ids                 | list(string)   | List of private DNS zone IDs                      | ["/subscriptions/56bdaed4-70cf-4a28-8fb8-0efc135bb29f/resourceGroups/rg-azuredns-prd-01/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]         |
| subresource_names                    | list(string)   | List of subresource names                         | ["blob"]   |
| ip_rules                             | list(string)   | Public IPs/CIDRs allowed through the storage firewall | []     |

## Outputs

| Name                                 | Description                           |
|---------------------------------------|---------------------------------------|
| storage_account_id                    | Storage Account resource ID           |
| storage_account_name                  | Storage Account name                  |
| storage_account_primary_access_key    | Storage Account primary access key    |

## Features

- Secure, configurable storage account creation
- Private Endpoint integration
- Storage firewall allow-list for public IPs/CIDRs via `ip_rules` (default action remains Deny)
- Tagging support
- Logs sent to Splunk

## Requirements

- Terraform >= 1.4.0
- AzureRM >= 3.0
