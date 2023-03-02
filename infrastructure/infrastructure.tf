###########################################################
### Default configuration block when working with Azure ###
###########################################################
terraform {
  # Provide configuration details for Terraform
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.90"
    }
  }
  # This block allows us to save the terraform.tfstate file on the cloud, so a team of developers can use the terraform
  # configuration to update the infrastructure.
  # Link: https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli
  # Note.- Before using this block, is important that the resource group, storage account and container ARE DEPLOYED.
  backend "azurerm" {
    resource_group_name  = "dip-prd-master-rg"
    storage_account_name = "dipprdmasterst"
    container_name       = "dip-prd-asdlgen2-fs-config"
    key                  = "dip-14as69-rg/terraform.tfstate"
    
  }
}

# provide configuration details for the Azure terraform provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}


# For naming conventions please refer to:
# https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules

# Get info about current user
data "azuread_client_config" "current" {}


###########################################################
###################  Resource Group #######################
###########################################################
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "${var.default_prefix}-${var.random_id}-rg"
  tags = {
    owner       = var.owner
    environment = var.environment

  }
}

# Add Ownership roles for the resource group to the list of contributors.
# Note.- Admins do not need to be added. They are already owners of the subscription, so they will inherit the ownershipt for this resource group. Otherwise there will be listed twice.
resource "azurerm_role_assignment" "roles_on_rg_for_contributors" {
  for_each = toset(var.contributors_object_ids)
  role_definition_name = "Owner" # "Owner" | "Contributor" | azurerm_role_definition.rd.name
  scope                = azurerm_resource_group.rg.id
  principal_id         = each.key
}


###########################################################
###################  Storage Account ######################
###########################################################
resource "azurerm_storage_account" "storageaccount" {
  name = "${var.default_prefix}${var.random_id}st" # Between 3 to 24 characters and
                                                                     # UNIQUE within Azure
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"

  tags = {
    owner       = var.owner
    environment = var.environment
  }
}


###########################################################
###################  App Service Plan #####################
###########################################################
resource "azurerm_app_service_plan" "service_plan_prd" {
  name                = "${var.default_prefix}-${var.random_id}-service-plan-prd"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service_plan" "service_plan_dev" {
  name                = "${var.default_prefix}-${var.random_id}-service-plan-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}


###########################################################
#####################  App Function #######################
###########################################################
resource "azurerm_function_app" "function_app_prd" {
  name                       = "${var.default_prefix}-${var.random_id}-function-app-prd"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.service_plan_prd.id
  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key
}

resource "azurerm_function_app" "function_app_dev" {
  name                       = "${var.default_prefix}-${var.random_id}-function-app-dev"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.service_plan_dev.id
  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key
}
