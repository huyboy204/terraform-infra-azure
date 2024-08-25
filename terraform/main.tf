module "vpc" {
  source = "../module/network"

  rg_name          = var.rg_name
  location         = var.location
  tags             = var.tags
  vnet_name        = "${var.vnet_name}-${local.owner}-${local.region}-${local.environment}-${local.projectname}"
  address_space    = var.address_space
  subnet_name      = "${var.subnet_name}-${local.owner}-${local.region}-${local.environment}-${local.projectname}"
  address_prefixes = var.address_prefixes
  nsg_name         = "${var.nsg_name}-${local.owner}-${local.region}-${local.environment}-${local.projectname}"
}

module "lb" {
  source = "../module/lb"

  rg_name               = var.rg_name
  location              = var.location
  tags                  = var.tags
  pip_name              = "${var.pip_name}-${local.owner}-${local.region}-${local.environment}-${local.projectname}"
  pip_allocation_method = var.pip_allocation_method
  pip_sku               = var.pip_sku
  lb_name               = "${var.lb_name}-${local.owner}-${local.region}-${local.environment}-${local.projectname}"
  lb_sku                = var.lb_sku

  depends_on = [module.vpc]
}

module "vmss" {
  source = "../module/vmss"

  rg_name          = var.rg_name
  location         = var.location
  tags             = var.tags
  vnet_name        = "${var.vnet_name}-${local.owner}-${local.region}-${local.environment}-${local.projectname}"
  subnet_name      = "${var.subnet_name}-${local.owner}-${local.region}-${local.environment}-${local.projectname}"
  lb_name          = "${var.lb_name}-${local.owner}-${local.region}-${local.environment}-${local.projectname}"
  default_intances = var.default_intances
  available_zones = var.available_zones
  image_id         = var.image_id
  admin_user       = var.admin_user

  depends_on = [module.vpc, module.lb]
}

# resource "azurerm_network_interface" "baston" {
#   name                = "baston-nic"
#   location            = var.location
#   resource_group_name = var.rg_name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.baston.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_linux_virtual_machine" "baston" {
#   name                = "baston-machine"
#   resource_group_name = var.rg_name
#   location            = var.location
#   size                = "Standard_F2"
#   admin_username      = "adminuser"
#   network_interface_ids = [
#     azurerm_network_interface.baston.id,
#   ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("C:/Users/huyld/.ssh/id_rsa.pub")
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "StandardSSD_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#     version   = "latest"
#   }


#   depends_on = [ azurerm_network_interface.baston ]
# }