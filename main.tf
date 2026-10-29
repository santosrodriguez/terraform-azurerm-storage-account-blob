resource "azurerm_storage_account" "storageaccount" {
    name                       = var.storage_account_name
    resource_group_name        = var.resource_group_name
    location                   = var.location
    account_kind               = var.account_kind
    account_tier               = var.account_tier
    account_replication_type   = var.account_replication_type
    https_traffic_only_enabled  = var.https_traffic_only_enabled
    min_tls_version            = var.min_tls_version
    allow_nested_items_to_be_public = false
    public_network_access_enabled =  var.storage_account_public_network_access_enabled
    tags                       = var.tags
    network_rules {
      default_action = "Deny"
      bypass         = ["None"]
      ip_rules       = var.ip_rules
    }
    blob_properties {
      delete_retention_policy {
        days = 30
      }
      container_delete_retention_policy {
        days = 30
      }
    }
}

resource "azurerm_private_endpoint" "endpoint" {
  name                = "pe-${azurerm_storage_account.storageaccount.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.storage_private_endpoint_subnet_id
  private_service_connection {
    name                           = "connection-pe-${azurerm_storage_account.storageaccount.name}"
    private_connection_resource_id = azurerm_storage_account.storageaccount.id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
  }
  tags       = var.tags
  depends_on = [azurerm_storage_account.storageaccount]

  private_dns_zone_group {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = var.private_dns_zone_ids

  }
}

locals {
  storage_services = [
    { name = "blob",   resource_suffix = "blobServices/default/",   diag_name = "diagsetting-blob"  },
    { name = "queue",  resource_suffix = "queueServices/default/",  diag_name = "diagsetting-queue" },
    { name = "table",  resource_suffix = "tableServices/default/",  diag_name = "diagsetting-table" },
    { name = "file",   resource_suffix = "fileServices/default/",   diag_name = "diagsetting-file"  }
  ]
}

resource "azurerm_monitor_diagnostic_setting" "logs" {
  for_each                       = { for svc in local.storage_services : svc.name => svc }
  name                           = each.value.diag_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id
  eventhub_name                  = var.eventhub_name
  target_resource_id             = "${azurerm_storage_account.storageaccount.id}/${each.value.resource_suffix}"
  storage_account_id             = azurerm_storage_account.storageaccount.id

  enabled_log {
    category_group = "audit"
  }
}
