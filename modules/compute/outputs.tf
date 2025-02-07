output "azure_vm_ip" {
  value = length(azurerm_virtual_machine.azure_vm) > 0 ? azurerm_virtual_machine.azure_vm[0].public_ip_address : null
}

output "aws_vm_ip" {
  value = length(aws_instance.aws_vm) > 0 ? aws_instance.aws_vm[0].public_ip : null
}
