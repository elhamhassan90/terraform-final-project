output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "public_lb_dns_name" {
  value = module.lb.public_lb_dns_name
}

output "private_lb_dns_name" {
  value = module.lb.private_lb_dns_name
}

