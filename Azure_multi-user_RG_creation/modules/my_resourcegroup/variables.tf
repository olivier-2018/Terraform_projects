# Module variables
variable "resource_group_location" {
  type        = string
  description = "The location/region where the resource group will be created"
  default     = "westeurope"
}

variable "resource_name" {
  type = string
}

variable "resource_contributors" {
  type = list(string)
}
