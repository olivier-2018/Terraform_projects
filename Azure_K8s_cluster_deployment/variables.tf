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

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 1
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "useraks"
}
