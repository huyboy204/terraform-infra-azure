variable "rg_name" {
  type    = string
  default = "rg"
}

variable "location" {
  type    = string
  default = "eastasia"
}

variable "vnet_name" {
  type    = string
  default = "my-vnet"
}

variable "subnet_name" {
  type    = string
  default = "my-subnet"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "Dev"
    owner       = "huyldq1"
    projectname = "azure-lab"
  }
}

variable "lb_name" {
  type    = string
  default = "my-lb"
}

variable "default_intances" {
  type = number
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
