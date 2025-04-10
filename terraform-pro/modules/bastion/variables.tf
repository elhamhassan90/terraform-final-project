variable "subnet_id" {
  type        = string
  description = "Public subnet ID for the Bastion Host"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID to attach to Bastion Host"
}

variable "key_name" {
  type        = string
  description = "Key pair name for SSH access"
}

