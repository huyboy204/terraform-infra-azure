
# Create public IPs
resource "azurerm_public_ip" "lbpip" {
  name                = var.pip_name
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = var.pip_allocation_method
  sku                 = var.pip_sku

  tags = var.tags
}

# Create load balancer 
resource "azurerm_lb" "lbr" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.lb_sku

  tags = var.tags

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lbpip.id
  }
}

# Create backend address pool
resource "azurerm_lb_backend_address_pool" "bepool" {
  loadbalancer_id = azurerm_lb.lbr.id
  name            = "BackEndAddressPool"
}

# Create a health probe
resource "azurerm_lb_probe" "lbprobe" {
  loadbalancer_id     = azurerm_lb.lbr.id
  name                = "http-probe"
  protocol            = "Http"
  request_path        = "/"
  port                = 80
}

# Create a load balancing rule
resource "azurerm_lb_rule" "lbrulehttp" {
  loadbalancer_id                = azurerm_lb.lbr.id
  name                           = "LBRuleHTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.lbprobe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
}

# Create load balancing rule for HTTPS
resource "azurerm_lb_rule" "lbrulehttps" {
  loadbalancer_id                = azurerm_lb.lbr.id
  name                           = "LBRuleHTTPS" 
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.lbprobe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
}