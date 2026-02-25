# Random suffix for unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}
# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${terraform.workspace}-${random_string.suffix.result}"
  location = var.location
   tags = {
    Environment = terraform.workspace
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}
# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = lower("st${var.project_name}${terraform.workspace}${random_string.suffix.result}")
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = terraform.workspace == "prod" ? "GRS" : "LRS"
    tags = {
        Environment = terraform.workspace
        ManagedBy   = "Terraform"
        Project     = var.project_name
    }
}
