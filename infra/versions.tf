terraform {
  required_version = "~> 1.15"
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 6.38" 
    }
    azurerm = {
      version = "~> 4.2"
        source  = "hashicorp/azurerm"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "terraform"
    storage_account_name  = "osamahdevopsterraform"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
