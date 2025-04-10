variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  description = "Security Group ID to attach to EC2"
  type        = string
}

variable "bastion_ip" {
  type        = string
  description = "Public IP of the bastion host used for SSH into private instances"
}

