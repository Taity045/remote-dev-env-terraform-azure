terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110.0"
    }

  }
}

provider "azurerm" {

  features {}
}

resource "azurerm_resource_group" "learn-azure" {
  name     = "learn-azure"
  location = "South Africa North"
  tags = {
    environment = "dev"
  }

}

resource "azurerm_virtual_network" "vnet" {
  name                = "learn-vnet"
  resource_group_name = azurerm_resource_group.learn-azure.name
  location            = azurerm_resource_group.learn-azure.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    environment = "dev"
  }

}

resource "azurerm_subnet" "learn-subnet" {
  name                 = "learn-subnet"
  resource_group_name  = azurerm_resource_group.learn-azure.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.123.1.0/24"]

}

resource "azurerm_network_security_group" "learn-sg" {
  name                = "learn-sg"
  location            = azurerm_resource_group.learn-azure.location
  resource_group_name = azurerm_resource_group.learn-azure.name

  tags = {
    environment = "dev"
  }

}

resource "azurerm_network_security_rule" "learn-azure-dev-rule" {
  name                        = "learn-azure-dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.learn-azure.name
  network_security_group_name = azurerm_network_security_group.learn-sg.name
}

resource "azurerm_subnet_network_security_group_association" "learn-azure-sga" {
  subnet_id                 = azurerm_subnet.learn-subnet.id
  network_security_group_id = azurerm_network_security_group.learn-sg.id

}

resource "azurerm_public_ip" "learn-public-ip" {
  name                = "learn-public-ip"
  resource_group_name = azurerm_resource_group.learn-azure.name
  location            = azurerm_resource_group.learn-azure.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "learn-azure-nic" {
  name                = "learn-azure-nic"
  location            = azurerm_resource_group.learn-azure.location
  resource_group_name = azurerm_resource_group.learn-azure.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.learn-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.learn-public-ip.id

  }

  tags = {
    environment = "dev"
  }

}

resource "azurerm_linux_virtual_machine" "learn-azure-vm" {
  name                  = "learn-azure-vm"
  resource_group_name   = azurerm_resource_group.learn-azure.name
  location              = azurerm_resource_group.learn-azure.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.learn-azure-nic.id]


  custom_data = filebase64("customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/learnazurekey.pub")
  }


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-script.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = "~/.ssh/learnazurekey"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]

  }

  tags = {
    environment = "dev"


  }

}

data "azurerm_public_ip" "learnazure-ip-data" {
  name                = azurerm_public_ip.learn-public-ip.name
  resource_group_name = azurerm_resource_group.learn-azure.name
}

output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.learn-azure-vm.name}: ${data.azurerm_public_ip.learnazure-ip-data.ip_address}"

}