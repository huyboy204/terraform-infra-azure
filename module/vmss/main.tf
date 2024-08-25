data "azurerm_subnet" "vmss" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
}

data "azurerm_lb" "lb" {
  name                = var.lb_name
  resource_group_name = var.rg_name
}

data "azurerm_lb_backend_address_pool" "lb_be" {
  name            = "BackEndAddressPool"
  loadbalancer_id = data.azurerm_lb.lb.id
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "vmscaleset"
  location            = var.location
  resource_group_name = var.rg_name
  upgrade_policy_mode = "Manual"

  zones = var.available_zones

  sku {
    name     = "Standard_B1s"
    tier     = "Standard"
    capacity = var.default_intances
  }

  storage_profile_image_reference {
    id = var.image_id
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "vmlab"
    admin_username       = var.admin_user
    # admin_password       = ""
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = file("C:/Users/huyld/.ssh/id_rsa.pub")
    }
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = data.azurerm_subnet.vmss.id
      load_balancer_backend_address_pool_ids = [data.azurerm_lb_backend_address_pool.lb_be.id]
      primary                                = true
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "myAutoscaleSetting"
  resource_group_name = var.rg_name
  location            = var.location
  target_resource_id  = azurerm_virtual_machine_scale_set.vmss.id

  tags = var.tags

  profile {
    name = "defaultProfile"

    capacity {
      default = var.default_intances
      minimum = var.default_intances
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}

resource "azurerm_monitor_action_group" "vmss_actiongroup" {
  name                = "vmss-actiongroup"
  short_name = "vmssaction" 
  resource_group_name = var.rg_name
  
  tags = var.tags

  email_receiver {
    name          = "VMSS Trigger"
    email_address = "huyboy204@gmail.com"
  }
}

resource "azurerm_monitor_metric_alert" "vmss_alert" {
  name                = "vmss-alert"
  resource_group_name = var.rg_name

  tags = var.tags

  scopes = [
    azurerm_virtual_machine_scale_set.vmss.id
  ]

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets" 
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.vmss_actiongroup.id 
  }
}