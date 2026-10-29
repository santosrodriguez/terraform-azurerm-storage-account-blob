variable "storage_account_name" {
    type = string
    validation {
      condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24
      error_message = "The storage account name must be between 3 and 24 characters long."

    }
}

variable "resource_group_name" {
    type = string
}

variable "location" {
  type        = string
  description = "Azure region location"
  validation {
    condition = contains(
      ["eastus", "westus", "northcentralus"], var.location
    )
    error_message = "Error: Location is not valid. Valid options are eastus, westus, or northcentralus."
  }
  default = "eastus"
}


variable "tags" {
  type = map(string)
  description = "Tags"
  #validation {
  #  condition = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner")
  #  error_message = "You must provide both 'environment' and 'owner' tags."
  #}
}

variable "account_kind" {
  type = string
  validation {
    condition     = contains(["StorageV2", "BlobStorage"], var.account_kind)
    error_message = "Invalid account_kind. Allowed values: StorageV2, BlobStorage. These are required for allow_blob_public_access."
  }
  default = "StorageV2"
}
variable "account_tier" {
  type = string
  description = "Storage account tier."
  default = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Invalid account_tier. Allowed values: Standard, Premium."
  }
}
variable "account_replication_type" {
  type = string
  description = "Storage account replication type."
  default = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Invalid account_replication_type. Allowed values: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}
variable  "https_traffic_only_enabled" {
    type = bool
    default = true
}

variable  "blob_public_access_enabled" {
    type = bool
    default = false
}
variable  "min_tls_version" {
    type = string
    description = "Storage account minimum TLS version."
    default = "TLS1_2"
}
variable  "storage_account_public_network_access_enabled" {
    type = bool
    default = false
}
variable  "private_dns_zone_ids" {
    type = list(string)
    default = ["/subscriptions/56bdaed4-70cf-4a28-8fb8-0efc135bb29f/resourceGroups/rg-azuredns-prd-01/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]

}
variable  "storage_private_endpoint_subnet_id" {
    type = string
    description = "Storage account private endpoint subnet ID."
}

variable  "private_dns_zone_group_name" {
    type = string
    description = "Specifies the Name of the Private DNS Zone Group."
    default = "default"
}
variable  "subresource_names" {
    type = list(string)
    description = "A list of subresource names which the Private Endpoint is able to connect to."
    default = ["blob"]
}

variable "eventhub_authorization_rule_id" {
  type        = string
  description = "The Event Hub authorization rule ID for diagnostic settings."
  default     = "/subscriptions/56bdaed4-70cf-4a28-8fb8-0efc135bb29f/resourceGroups/LOGS_RG/providers/Microsoft.EventHub/namespaces/evh-sharedsvcseastus/authorizationRules/RootManageSharedAccessKey"
}

variable "eventhub_name" {
  type        = string
  description = "The Event Hub name for diagnostic settings."
  default     = "cs-resource_resourcelogs"
}

variable "ip_rules" {
  type        = list(string)
  description = "Public IPs/CIDRs allowed through the storage firewall."
  default     = []
}
