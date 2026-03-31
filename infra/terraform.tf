terraform {
    required_version = ">= 1.5.0"

    backend "azurerm" { 
        resource_group_name  = "terraform-state-rg" 
        storage_account_name = "tfstater3rls"
        container_name       = "tfstate"
        key                  = "prod.terraform.tfstate"
    }

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">= 4.61.0"
        }
    }
}