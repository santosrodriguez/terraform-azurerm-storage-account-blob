output "storage_account_id" {
    value = azurerm_storage_account.storageaccount.id
}

output "storage_account_name" {
    value = azurerm_storage_account.storageaccount.name
}

output "storage_account_primary_access_key" {
    value = azurerm_storage_account.storageaccount.primary_access_key
}
