packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = ">= 2.0.1"
    }
  }
}

variable "client_id" {
  type = string
  sensitive   = true
  default = ""
}

variable "client_secret" {
  type = string
  sensitive   = true
  default = ""
}

variable "subscription_id" {
  type = string
  sensitive   = true
  default = ""
}

variable "tenant_id" {
  type = string
  sensitive   = true
  default = ""
}

variable "managed_image_name" {
  type = string
  default = "u20-nginx"
}

variable "managed_image_resource_group_name" {
  type = string
  default = "images"
}

variable "image_publisher" {
  type    = string
  default = "canonical"
}

variable "image_offer" {
  type    = string
  default = "0001-com-ubuntu-server-focal"
}

variable "image_sku" {
  type    = string
  default = "20_04-lts"
}

variable "location" {
  type    = string
  default = "East Asia"
}

variable "vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "os_type" {
  type = string
  default = "Linux"
}

source "azure-arm" "image-build" {
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id
  image_publisher                   = var.image_publisher
  image_offer                       = var.image_offer
  image_sku                         = var.image_sku
  location                          = var.location
  managed_image_name                = var.managed_image_name
  managed_image_resource_group_name = var.managed_image_resource_group_name
  os_type                           = var.os_type
  vm_size                           = var.vm_size
}

build {
  sources = ["source.azure-arm.image-build"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = [
      "apt-get update", "apt-get upgrade -y", 
      "apt-get -y install nginx", 
      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync", 
      "echo '<h1>Hello World from !! huyldq1 and VM image create by Huy !!</h1>' > /var/www/html/index.nginx-debian.html", 
      "systemctl enable nginx", 
      "systemctl start nginx"
    ]
    inline_shebang  = "/bin/sh -x"
  }
}