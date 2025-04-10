variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ec2_public_map" {
  type = map(string)
}

variable "ec2_private_map" {
  type = map(string)
}

variable "security_group_id" {
  type = string
}

