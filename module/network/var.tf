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

variable "vnet_name" {
  type    = string
  default = "my-vnet"
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type    = string
  default = "my-subnet"
}

variable "address_prefixes" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "nsg_name" {
  type    = string
  default = "my-nsg"
}