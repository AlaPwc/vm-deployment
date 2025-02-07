variable "enable_azure" { default = false }
variable "enable_aws" { default = false }

# Azure Variables
variable "azure_vm_name" {}
variable "azure_location" {}
variable "azure_resource_group" {}
variable "azure_network_interface_id" {}
variable "azure_vm_size" {}

# AWS Variables
variable "aws_vm_name" {}
variable "aws_ami" {}
variable "aws_subnet_id" {}
variable "aws_vm_size" {}
variable "aws_key_name" {}

# Common Variables
variable "admin_username" {}
variable "admin_password" {}
