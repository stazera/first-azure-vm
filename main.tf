terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "3.11.0"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "main" {
    name = var.resourcegroup_name
    location = var.rg_location
}

resource "azurerm_virtual_network" "main" {
    name = "asn"
    resource_group_name = azurerm_resource_group.main.name
    address_space = var.vnet_cidr
    location = var.vpc_location
}

resource "azurerm_subnet" "public" {
    name = var.public_sn_name
    resource_group_name = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes = var.public_sn_cidr
}

resource "azurerm_public_ip" "ip" {
    name = var.ip_name
    resource_group_name = azurerm_resource_group.main.name
    # location = var.ip_location
    location =var.vpc_location
    allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "nic"{
    name = var.nic_name
    # location = var.nic_location
    location =var.vpc_location
    resource_group_name = azurerm_resource_group.main.name
    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.public.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.ip.id
    }
}

resource "azurerm_network_security_group" "public" {
    name = var.nsg_name
    resource_group_name = azurerm_resource_group.main.name
    location =var.vpc_location
    # location = var.nsg_location
    
    security_rule {
        name                       = "allow_ssh"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "associate" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_linux_virtual_machine" "asn-vm" {
    name                = "asn-Test-VM"
    resource_group_name = azurerm_resource_group.main.name
    location            = azurerm_resource_group.main.location
    size                = "Standard_B1s"
    admin_username      = "adminuser"
    # delete_os_disk_on_termination = true

    network_interface_ids = [
        azurerm_network_interface.nic.id,
        ]

    admin_ssh_key {
        username   = "adminuser"
        public_key = file("~/.ssh/stazera.pub")
        }
    
    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
        }
    
    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
        }
}
