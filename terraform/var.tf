variable "rg_name" {
  type    = string
  default = "huyldq1"
}

variable "location" {
  type    = string
  default = "East Asia"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
    owner       = "huyldq1"
    projectname = "azure-lab"
    region      = "ea"
  }
}

locals {
  environment = lookup(var.tags, "environment")
  owner       = lookup(var.tags, "owner")
  projectname = lookup(var.tags, "projectname")
  region      = lookup(var.tags, "region")
}

variable "vnet_name" {
  type    = string
  default = "vnet"
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type    = string
  default = "subnet"
}

variable "address_prefixes" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "nsg_name" {
  type    = string
  default = "nsg"
}

variable "pip_name" {
  type    = string
  default = "pip"
}

variable "pip_allocation_method" {
  type    = string
  default = "Static"
}

variable "pip_sku" {
  type    = string
  default = "Standard"
}

variable "lb_name" {
  type    = string
  default = "lb"
}

variable "lb_sku" {
  type    = string
  default = "Standard"
}

variable "default_intances" {
  type    = number
  default = 2
}

variable "available_zones" {
  type = list(number)
  default = [ 1,2,3 ]
}

variable "image_id" {
  type    = string
  default = "/subscriptions/a5b2fb36-2de8-4f3e-88ce-81d365b92474/resourceGroups/image/providers/Microsoft.Compute/images/u20-nginx"
}

variable "admin_user" {
  description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
  default     = "azureuser"
}