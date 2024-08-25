variable "rg_name" {
  type    = string
  default = "rg"
}

variable "location" {
  type    = string
  default = "East Asia"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "Dev"
    owner       = "huyldq1"
    projectname = "azure-lab"
  }
}

variable "pip_name" {
  type    = string
  default = "my-pip"
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
  default = "my-lb"
}

variable "lb_sku" {
  type    = string
  default = "Standard"
}