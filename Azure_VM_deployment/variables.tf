# Environment variables
variable "azure_subscriptionid" {}
variable "host_ip" {}
variable "my_azure_location" {}
variable "sshkey_location" {}

# Variable definitions
variable "host_os" {
  description = "The OS of the host"
  type        = string
  default     = "linux"
}

