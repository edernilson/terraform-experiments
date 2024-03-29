resource "azurerm_resource_group" "rg" {
  location = var.region
  name     = var.base_name
}

resource "azurerm_network_watcher" "rg" {
  name                = "${var.base_name}Watcher"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create virtual network
resource "azurerm_virtual_network" "portainer_network" {
  name                = "${var.base_name}Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "portainer_subnet" {
  name                 = "${var.base_name}Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.portainer_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "portainer_public_ip" {
  name                = "${var.base_name}PublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "portainer_nsg" {
  name                = "${var.base_name}NetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule    {
    name                       = "PORTAINER_AGENT"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9001"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule    {
    name                       = "HTTP"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }  
}

# Create network interface
resource "azurerm_network_interface" "portainer_nic" {
  name                = "${var.base_name}NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.base_name}NIC_Configuration"
    subnet_id                     = azurerm_subnet.portainer_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.portainer_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "portainer_nisgassociation" {
  network_interface_id      = azurerm_network_interface.portainer_nic.id
  network_security_group_id = azurerm_network_security_group.portainer_nsg.id
}

# Generate random text for a unique storage account name
# resource "random_id" "random_id" {
#   keepers = {
#     # Generate a new ID only when a new resource group is defined
#     resource_group = azurerm_resource_group.rg.name
#   }

#   byte_length = 8
# }

# Create storage account for boot diagnostics
# resource "azurerm_storage_account" "my_storage_account" {
#   name                     = "${var.base_name}StorageDiag${random_id.random_id.hex}"
#   location                 = azurerm_resource_group.rg.location
#   resource_group_name      = azurerm_resource_group.rg.name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "portainer_vm" {
  name                  = "${var.base_name}VM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.portainer_nic.id]
  size                  = "Standard_D2s_v3"

  os_disk {
    name                 = "${var.base_name}OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "${var.base_name}srv"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = file(var.public_ssh_key)     
  }

  # custom_data  = filebase64("${path.module}/dockerinstall.tpl")

  # boot_diagnostics {
  #   storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  # }

  connection {
        type = "ssh"
        user = var.username
        host = self.public_ip_address
        private_key = file(var.private_ssh_key)
        timeout = "4m"
        agent = false
  }

  provisioner "file" {
    source      = var.script_file
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }
}
