# Description: This file contains the Terraform code to deploy a Linux VM in Azure
#              with a public IP, network interface, and network security group.
#              The VM is created in a new resource group, virtual network, and subnet.
#              The network security group has two rules to allow inbound traffic on ports 22 and 443.
#              The public IP is associated with the network interface.
#              The VM is created with a custom data script to install Docker.
#              The public IP address is outputted at the end of the deployment.

# Resource group
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
resource "azurerm_resource_group" "my_RG" {
  name     = "myRG_using_TF"
  location = var.my_azure_location
  tags = {
    comment     = "Build from Terraform"
    environment = "Dev"
  }
}

# Virtual network
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "my_VNet" {
  name                = "myVN_using_TF"
  resource_group_name = azurerm_resource_group.my_RG.name
  location            = azurerm_resource_group.my_RG.location
  address_space       = ["192.168.0.0/16"]
  tags = {
    comment     = "Build from Terraform"
    environment = "Dev"
  }
}

# Subnet
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "my_Subnet1" {
  name                 = "mySubnet1_using_TF"
  resource_group_name  = azurerm_resource_group.my_RG.name
  virtual_network_name = azurerm_virtual_network.my_VNet.name
  address_prefixes     = ["192.168.1.0/24"]
}

# network security group
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "my_NSG" {
  name                = "myNSG_using_TF"
  resource_group_name = azurerm_resource_group.my_RG.name
  location            = azurerm_resource_group.my_RG.location

  tags = {
    comment     = "Build from Terraform"
    environment = "Dev"
  }
}

# Network security rule
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule
resource "azurerm_network_security_rule" "my_NSG_rule_https" {
  name                        = "myNSGRule_https"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "${var.host_ip}"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.my_RG.name
  network_security_group_name = azurerm_network_security_group.my_NSG.name
}
resource "azurerm_network_security_rule" "my_NSG_rule_ssh" {
  name                        = "myNSGRule_ssh"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${var.host_ip}"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.my_RG.name
  network_security_group_name = azurerm_network_security_group.my_NSG.name
}

# Network security group association
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "my_subnet1_NSG_association" {
  subnet_id                 = azurerm_subnet.my_Subnet1.id
  network_security_group_id = azurerm_network_security_group.my_NSG.id
}


# Public IP
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
resource "azurerm_public_ip" "my_PIP" {
  name                = "myPIP"
  resource_group_name = azurerm_resource_group.my_RG.name
  location            = azurerm_resource_group.my_RG.location
  sku                 = "Basic"
  allocation_method   = "Dynamic"
  tags = {
    comment     = "Build from Terraform"
    environment = "Dev"
  }
}

# Network interface
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
resource "azurerm_network_interface" "my_NIC" {
  name                = "myNIC"
  location            = azurerm_resource_group.my_RG.location
  resource_group_name = azurerm_resource_group.my_RG.name

  ip_configuration {
    name                          = "myNIC_IPConfig"
    subnet_id                     = azurerm_subnet.my_Subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_PIP.id
  }
}

# linux virtual machine
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
resource "azurerm_linux_virtual_machine" "my_VM" {
  name                = "myVM_ubuntu"
  resource_group_name = azurerm_resource_group.my_RG.name
  location            = azurerm_resource_group.my_RG.location
  size                = "Standard_B1s" # cheapest VM @ 0.005USD/hr
  admin_username      = "adminuser"

  # Define the custom data script to install Docker after deployment
  custom_data = filebase64("scripts/script_install-docker.tpl")

  # Define the admin SSH key
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${var.sshkey_location}.pub")
  }

  # Define the network interface
  network_interface_ids = [
    azurerm_network_interface.my_NIC.id
  ]

  # Define the OS disk type
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Define the linux source image reference
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # Define the local-exec provisioner to run a script after the VM is created
  # Note: that scripts adds the VM's public IP to the SSH config file for easy access from VScode
  provisioner "local-exec" {
    command = templatefile("scripts/script_${var.host_os}-ssh.tpl", {
      conectionname = "myVM_ubuntu",
      hostname      = self.public_ip_address,
      user          = "adminuser",
      identityfile  = var.ssh-key_location
    })
    interpreter = var.host_os == "linux" ? ["bash", "-c"] : ["PowerShell", "-Command"]
  }

  computer_name                   = "myVM_using_TF"
  disable_password_authentication = true
  tags = {
    comment     = "Build from Terraform"
    environment = "Dev"
  }
}

# Define data from TF generated information 
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources
data "azurerm_public_ip" "my_PIP_data" {
  name                = azurerm_public_ip.my_PIP.name
  resource_group_name = azurerm_resource_group.my_RG.name
}

# Outputs the public IP address
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/outputs
output "my_PIP_output" {
  value = "${azurerm_linux_virtual_machine.my_VM.name}: ${data.azurerm_public_ip.my_PIP_data.ip_address}"
}
