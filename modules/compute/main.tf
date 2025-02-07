# Create an Azure Virtual Machine if Azure is enabled
resource "azurerm_virtual_machine" "azure_vm" {
  count                 = var.enable_azure ? 1 : 0
  name                  = var.azure_vm_name
  location              = var.azure_location
  resource_group_name   = var.azure_resource_group
  network_interface_ids = [var.azure_network_interface_id]
  vm_size               = var.azure_vm_size
}
  storage_os_disk {
    name              = "${var.azure_vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = var.azure_vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  #source_image_reference {
   # publisher = "Canonical"
   # offer     = "UbuntuServer"
   # sku       = "18.04-LTS"
   # version   = "latest"
  #}


# Create an AWS EC2 Instance if AWS is enabled
resource "aws_instance" "aws_vm" {
  count         = var.enable_aws ? 1 : 0
  ami           = var.aws_ami
  instance_type = var.aws_vm_size
  subnet_id     = var.aws_subnet_id
  key_name      = var.aws_key_name

  tags = {
    Name = var.aws_vm_name
  }
}
