output "public_lb_dns_name" {
  value = aws_lb.public.dns_name
}

output "private_lb_dns_name" {
  value = aws_lb.private.dns_name
}

