rg_name  = "huyldq1"
location = "East Asia"
tags = {
  environment = "dev"
  owner       = "huyldq1"
  projectname = "azure-lab"
  region      = "ea"
}

vnet_name     = "vnet"
address_space = ["10.0.0.0/16"]

subnet_name      = "subnet"
address_prefixes = ["10.0.1.0/24"]

nsg_name = "nsg"

pip_name              = "pip"
pip_allocation_method = "Static"
pip_sku               = "Standard"

lb_name = "lb"
lb_sku  = "Standard"

default_intances = 1
available_zones = [ 1,2,3 ]

image_id = "/subscriptions/a5b2fb36-2de8-4f3e-88ce-81d365b92474/resourceGroups/image/providers/Microsoft.Compute/images/u20-nginx"

admin_user = "azureuser"