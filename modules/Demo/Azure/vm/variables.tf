variable "resource_group_location" {
  default     = "ger-central"
  description = "Location of the resource group."
}


variable "prefix" {
  type        = string
  default     = "win-vm-iis"
  description = "Prefix of the resource name"
}