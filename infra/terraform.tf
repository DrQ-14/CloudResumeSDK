terraform {
    required_version = ">= 1.5.0"
    
    backend "local" {
        path = "terraform.tfstate"
    }

    #backend "azurerm" { 
     #   resource_group_name  = "terraform-state-rg" 
      #  storage_account_name = "tfstatestorage"
       # container_name       = "tfstate"
        #key                  = "prod.terraform.tfstate"
    #}

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 3.0"
        }
    }
}